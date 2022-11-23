Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749DD63694D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbiKWSwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbiKWSwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:52:38 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F0865B4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:52:38 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id o5-20020a4aa805000000b004a020f841cbso234292oom.3
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2AOkVdEeQtC5gq/6x2nrWd17Nb2VCVw9yChU5bqPBdc=;
        b=Dh82r47AW+MuhtdfDiweECR0qN6fmOJ38pbqj1vsXtT05m0pFhvZV7RvkTIyTVyElL
         joU+FnBIrvoFM+cZNegWX55hFSSURJgshVlvGxSLoUbVZOIbeEX03jyLY9ZlIYx0n10/
         FOCJnDVBooXlCdfTd8TQMFGNGlh3fD7wjFH/E8wkjQGqVB/mE6kduQd3cvmSrQxCTAW+
         82+tzwQpnx8q/nMLP31Fi/SOvwew/pO5Wq5iIxAlpxhmNvBxat2McRAjWwwIN7FWl9sr
         af4Crc31pYR0EdKUZyBEZuhE0PpQuaiUGNRPdo/nIWOgjwwlvBwNUO6oEu+QbjkXg7PY
         VSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2AOkVdEeQtC5gq/6x2nrWd17Nb2VCVw9yChU5bqPBdc=;
        b=Y10C8tiAbrSrO+7uvxMzhF1UbmXn0Cg+emyCsvCcGoebesaq3PFqIx8JjbGPbqw3Ky
         +i5GCc7iTwaweQRmaeP98XL9dOBnT3WPvmAilPg0DaUMUIvFrqb+2KMcVgdKOo0uE5dx
         T2Subeeiqj6x/2HpOBpv03Kl2nvwz55251fbCXMfq7oF/NR1I3irjDpqBW/ZlNQUqTwJ
         yAsoGVfUuwvJe+LnpH7T5/LP+rN/GCZTg6oHvXYxt7lm3ZFa76bbFfz+5fU1SoANDj9S
         pWV2GqqTayUkEm2tfOZfbyZ/pVxA/x7Shxn5Q9Bh+TWU2hctHqchgnT/jZc+u21pg/wT
         czxw==
X-Gm-Message-State: ANoB5pnlgSI+HIKfZpOM/WK/pFmXULld46LUvqHlZ3lYvNg/8X0Xei8t
        3vPKLOcYKkEonqdQbDLFSQo=
X-Google-Smtp-Source: AA0mqf7delJ1OePTvcDdfe6+lZYVUVWWfiSlPguuFJUJkUEY6P1OqGkEa20Zxc6cJJ5FqqzyQfj+kw==
X-Received: by 2002:a4a:347:0:b0:49e:f7eb:b2a9 with SMTP id 68-20020a4a0347000000b0049ef7ebb2a9mr4361839ooi.3.1669229557423;
        Wed, 23 Nov 2022 10:52:37 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id n18-20020a056870241200b00140d421445bsm9548486oap.11.2022.11.23.10.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 10:52:36 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 24015459D3A; Wed, 23 Nov 2022 15:52:35 -0300 (-03)
Date:   Wed, 23 Nov 2022 15:52:35 -0300
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
Subject: Re: [PATCHv2 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
Message-ID: <Y35r87foLmKAblMg@t14s.localdomain>
References: <cover.1669138256.git.lucien.xin@gmail.com>
 <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:32:21PM -0500, Xin Long wrote:
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -52,7 +52,7 @@ obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
>  obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
>  obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
>  
> -nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
> +nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o nf_nat_ovs.o

Considering that the code in nf_nat_ovs is only used if ovs or act_ct
are enabled, shouldn't it be using an invisible knob here that gets
automatically selected by them? Pablo?

I think this is my last comment on this series. The rest LGTM.

>  
>  obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
>  
