Return-Path: <netdev+bounces-5827-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE17B71303E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 684B32818E0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 23:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6582D24E;
	Fri, 26 May 2023 23:10:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6BF15B7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 23:10:00 +0000 (UTC)
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3E2D3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:09:58 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-6238200c584so8282146d6.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685142597; x=1687734597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wZCQ/zmDhMWK7FbW3mg7XoO1X/Mk8hZfeTBPljDiVAs=;
        b=E/i8IYu9c/yOhhUqxnLtYMEoCX5oxDqgRxDEbKl7qhO3zjjAtLWF2EuIdVz2pizeoU
         0jxFHmYDSkeyjaKLt2TrSNRtcOUpkOeKZK5zjHE31JT0GYKu17YxYOhWxPD7Frsw/QTB
         wGRG4R13eBIVCCIz6vNpNjT6xKesgG4aNocAcWfi4rpyGcEsD9VhGQ32nE9+k6dPX8ls
         j0Er21YCuuv2NL6n8npMl0wBnYcWTFMtyaj2E3ZxMTXpVwD1N0RqJj05l5xBbZsj/Kub
         LS0wlqq+7FgMwQYBNmgZFQLyp32wtiouQ7e5ayvfyMjXZp2etZprI/a1nHM2B8/D6qii
         RmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685142597; x=1687734597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZCQ/zmDhMWK7FbW3mg7XoO1X/Mk8hZfeTBPljDiVAs=;
        b=aIIV4gEMaRJil8bum4hTAFPVhnd4yX4zdLQTN3vQ+rr+5uMtmIW8OLULLEwUlcRDM+
         YMxHMQo5BRvd+aXKYtdddbRrmwtCC6sm/sgfM4PB70vmII7++857BgCJeA4+bjFeJx0B
         TMFo7SdXEPQHRxBgXLrkD7VuUfsH7LIncegP42kiPMja070KGGTVfkiZ5Ft8gppIQPK5
         qKEj5z+KhzBynRYJHkI0GiLV07OG3oCqB4assjuX8/vo+JLQkZBZGVTXyYV0HO1Iqx57
         Sx11U5tcIaGinRlTClLHOETlGMCXgNQOvvAxvGYiCruprXb2Z61fl79QcYhHp9zbb2F9
         EaSQ==
X-Gm-Message-State: AC+VfDycJUDCHt4jz0pmqKFBqP+ju5vbvVCdEnm43f9qhDDW+qfe4gKX
	OxLYsFORuGXExdmrUHca6g==
X-Google-Smtp-Source: ACHHUZ5VDqhIspTQOrhVouBtiEkvpj50gn6g+bnNrmTwSkufSQvLoipCPh/tTXccltU50yBUkAUIrg==
X-Received: by 2002:a05:6214:1c48:b0:625:88f5:7c3d with SMTP id if8-20020a0562141c4800b0062588f57c3dmr4622677qvb.1.1685142597407;
        Fri, 26 May 2023 16:09:57 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:3479:636a:f7f5:a17f])
        by smtp.gmail.com with ESMTPSA id c26-20020a056214071a00b005dd8b9345b9sm1555712qvz.81.2023.05.26.16.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 16:09:57 -0700 (PDT)
Date: Fri, 26 May 2023 16:09:51 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
 <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
 <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 05:21:34PM -0300, Pedro Tammela wrote:
> On 26/05/2023 16:47, Jamal Hadi Salim wrote:
> > [...] Peilin, Pedro will post the new repro.
> 
> We tweaked the reproducer to:
> ---
> r0 = socket$netlink(0x10, 0x3, 0x0)
> r1 = socket(0x10, 0x803, 0x0)
> sendmsg$nl_route_sched(r1, &(0x7f0000000300)={0x0, 0x0,
> &(0x7f0000000240)={&(0x7f0000000380)=ANY=[], 0x24}}, 0x0)
> getsockname$packet(r1, &(0x7f0000000200)={0x11, 0x0, <r2=>0x0, 0x1, 0x0,
> 0x6, @broadcast}, &(0x7f0000000440)=0x14)
> sendmsg$nl_route(r0, &(0x7f0000000040)={0x0, 0x0,
> &(0x7f0000000000)={&(0x7f0000000080)=ANY=[@ANYBLOB="480000001000050700"/20,
> @ANYRES32=r2, @ANYBLOB="0000000000000000280012000900010076657468"], 0x48}},
> 0x0)
> sendmsg$nl_route_sched(0xffffffffffffffff, &(0x7f00000002c0)={0x0, 0x0,
> &(0x7f0000000280)={&(0x7f0000000540)=@newqdisc={0x30, 0x24, 0xf0b, 0x0, 0x0,
> {0x0, 0x0, 0x0, r2, {}, {0xfff1, 0xffff}},
> [@qdisc_kind_options=@q_ingress={0xc}]}, 0x30}}, 0x0)
> sendmsg$nl_route_sched(0xffffffffffffffff, &(0x7f0000000340)={0x0, 0x0,
> &(0x7f00000000c0)={&(0x7f0000000580)=@newtfilter={0x3c, 0x2c, 0xd27, 0x0,
> 0x0, {0x0, 0x0, 0x0, r2, {}, {0xfff1, 0xffff}, {0xc}},
> [@filter_kind_options=@f_flower={{0xb}, {0xc, 0x2,
> [@TCA_FLOWER_CLASSID={0x8}]}}]}, 0x3c}}, 0x0)
> r4 = socket$netlink(0x10, 0x3, 0x0)
> sendmmsg(r4, &(0x7f00000002c0), 0x40000000000009f, 0x0)
> r5 = socket$netlink(0x10, 0x3, 0x0)
> sendmmsg(r5, &(0x7f00000002c0), 0x40000000000009f, 0x0)
> ---
> 
> We then generate the C program with:
> syz-prog2c -sandbox none -enable net_dev -threaded -repeat 0 -prog
> peilin.syz > repro.c
> 
> Now here comes a very important detail. The above will create a new net
> namespace to shoot the netlink messages. We are only able to reproduce the
> deadlock with your patches if we comment the creation of the new namespace
> out:
> ---
> diff --git a/repro.c b/repro.c
> index ee8eb0726..5cdbfb289 100644
> --- a/repro.c
> +++ b/repro.c
> @@ -1121,9 +1121,8 @@ static int do_sandbox_none(void)
>    sandbox_common();
>    drop_caps();
>    initialize_netdevices_init();
> -  if (unshare(CLONE_NEWNET)) {
> -  }
> +  // Doesn't seem to deadlock in a new netns
> +  // if (unshare(CLONE_NEWNET)) {
> +  // }
>    write_file("/proc/sys/net/ipv4/ping_group_range", "0 65535");
>    initialize_netdevices();
>    setup_binderfs();
> 
> ---
> 
> The reason we did this was to check on the event with 'tc mon'.
> The splat is quite big, see attached. It has all the indications of a
> deadlock in the rtnl_lock.

Thanks a lot, I'll get right on it.

Peilin Ye


