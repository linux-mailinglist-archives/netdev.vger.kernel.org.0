Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115836476C2
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHTpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiLHTpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:45:17 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39BF1D9
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:44:55 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id n205so2461096oib.1
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LyG4+qO9Ic34bJ4WUYaEPdk9Zs6piQbWnTNIIh2Fho0=;
        b=Kya2Ez644gCVd/fccSGJ720EQl5hz0qRa6kNob7dMN3JlLJU9Pd41LGBBq+bnHPvW1
         XmGvtVBSwqooD6JIy91p4MD9Cuzv7h/s5MV+B0yRyFB1RRB1/H1A3Z82xUDc/3A9YIqg
         WoFonSUPH5D3h4ONac+z/nyqWyoSOqm+sCC2lxL3fiaQWlG4nTvb1IcZ72E518OsB6hR
         ZMNFyFq6az5MibKGKbxdJk03CpkVDw0eBzP4pcCkERq8+BaaIrPJn0TakKBxgEeM1cdK
         IJyErXWW9SwgOGIGVA6+hAc2CMduXCUz6oi1nZVhrLsogUN4+QJL+HKT1QMrKJ+ruTM4
         WK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LyG4+qO9Ic34bJ4WUYaEPdk9Zs6piQbWnTNIIh2Fho0=;
        b=Kni2LDtmfz6ze3fV7Ny+YBrJ4c0I4W5lzkuSATLJ3jbfiipD6n0apRsONMu8DCgGW4
         4xP09XOZCJ0KCaGgJ3FTgtwuD3vXOkuUNRv3aGLNfvaWuWgx0jBVeL/HaglxsMPbxgHR
         5s724KvjZM/6eNMmeN9itqP/PmlnygBbQz71A3PYWnDZV3CNo9DlGxG7IF2rYxDnMEQh
         mjzoTA6UCHfCW+2tCjCrtRdD0pv113NJHyzNup1/BgrjBxFEHkrlKr1GYx7Rpy87uoT0
         JK9NxZj7cW1swD7mJov3h9OSmj+1NO9D/V/dCrbmDDCy5ebPF7G78W1S/Uz0LQ6E8DoI
         zsQA==
X-Gm-Message-State: ANoB5pm3ZQ4En7un/fNuDrUSS1P7mWqsl/zuYSj+21k1+kkVDUQ7PPXV
        OhXMvak/MOay6YP9DADxv2A=
X-Google-Smtp-Source: AA0mqf653I6oP9YioGMrhorcrpGBWzw10NMlRjMmLC2Oi+Ws9UrAVNKDEG3ilvuy8WNcLVQNzP5Hgg==
X-Received: by 2002:aca:d14:0:b0:35a:c014:9ca0 with SMTP id 20-20020aca0d14000000b0035ac0149ca0mr35684952oin.159.1670528695026;
        Thu, 08 Dec 2022 11:44:55 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:60de:7eb8:9d17:979d:1470])
        by smtp.gmail.com with ESMTPSA id o16-20020a056870969000b001428eb454e9sm14072646oaq.13.2022.12.08.11.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 11:44:54 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 6036948B820; Thu,  8 Dec 2022 16:44:52 -0300 (-03)
Date:   Thu, 8 Dec 2022 16:44:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCHv4 net-next 0/5] net: eliminate the duplicate code in the
 ct nat functions of ovs and tc
Message-ID: <Y5I+tKOZSATqz7Gz@t14s.localdomain>
References: <cover.1670518439.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670518439.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 11:56:07AM -0500, Xin Long wrote:
> The changes in the patchset:
> 
>   "net: add helper support in tc act_ct for ovs offloading"
> 
> had moved some common ct code used by both OVS and TC into netfilter.

Nice dedup.
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
