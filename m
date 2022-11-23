Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333B3635D0E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiKWMjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiKWMjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:39:31 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB2A65E62
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:39:30 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a7-20020a056830008700b0066c82848060so11118660oto.4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SziUpUBMpjw+UaQ7xC8676TMLbh0qm8Ns8XnOq6kTlM=;
        b=XnBarXAp7UiOAQLARwVD1vLf/Ue9JYvVP4CunY0+N6NJVh1c4y4I7XYJX5K1ahrlKl
         BrSA7knSxZ3Gc8usldf3XENHVYyPaG8YR5xcevytKtYFbLcLObzmRsfkPurgiUhNw8/j
         OQhsyMjLRyE2ODXgLFK5Vl4jdv6bIKy1ZhdNp6Rl+JNjaHlfD3FMG71RaFl5z8WdR/8P
         c8jacJQd5TdjdXo60PT3FomfRttbdDDdCxbrw5vE49SE573kI5te7ynT8mxl+vUbLwrx
         UG64ls3Uj9DNkC/mtxo6hf3OVwIiTR+9CUi+yxn1FtPUjtC0KYpjcrxtLw6MNtW6RR/q
         nhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SziUpUBMpjw+UaQ7xC8676TMLbh0qm8Ns8XnOq6kTlM=;
        b=wmB0CJpUyJtHgCu2OXSMEpmW04PHnsC3bf+s5Cy0aFF7MWgbYKzhk5xPEAIwhWvBhY
         ud/mLBpmNaGhtO/PZBxybu+RPe8/YAJ3dsiLhGlWq2/Jj2VAwU5PmOG8ihPIpsgOSqkW
         Rhripv45sVHViuuyi5chbtpcJKBf/O/mmUSY4Nv+o68WrHvYdNPMiYL/ej3UxnTr34CB
         L99uAsxxzhoga92UoFuaZedbTS9WplxNwXt3GlGBlOSyYHyBEffY9vk28Im4GRfpOtqa
         xYMvOso/0PUAYPgXqAlfznboYGkGOx3HJ+32uy42iyWCYss785DHq//omfxWTKXiHTpg
         3lEg==
X-Gm-Message-State: ANoB5pkrUmcnps9IibVyiC06+wPc9oQxjorOPCcB3cbhfoons4US21eb
        5oz+hahYLjYq6pf8W8gOCv0=
X-Google-Smtp-Source: AA0mqf7QTN322C9+VJcYEopl++6csZqV2LF3fwc0aCLFlWqiAj1Jp1hxQf9YB5bJDoQCvbbscdiHZQ==
X-Received: by 2002:a9d:4b08:0:b0:66e:1f02:1201 with SMTP id q8-20020a9d4b08000000b0066e1f021201mr531503otf.81.1669207169881;
        Wed, 23 Nov 2022 04:39:29 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id f16-20020a056871071000b0013ae5246449sm9062314oap.22.2022.11.23.04.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 04:39:29 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 6F984459C18; Wed, 23 Nov 2022 09:39:27 -0300 (-03)
Date:   Wed, 23 Nov 2022 09:39:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
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
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 0/5] net: eliminate the duplicate code in the
 ct nat functions of ovs and tc
Message-ID: <Y34Uf5lUYQ/wozOO@t14s.localdomain>
References: <cover.1669138256.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1669138256.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:32:16PM -0500, Xin Long wrote:
> The changes in the patchset:
> 
>   "net: add helper support in tc act_ct for ovs offloading"
> 
> had moved some common ct code used by both OVS and TC into netfilter.

Please give me today to review this patchset.

Thanks,
Marcelo
