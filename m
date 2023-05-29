Return-Path: <netdev+bounces-5985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2EF47143E0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94E26280DD2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704DE7F7;
	Mon, 29 May 2023 06:06:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4FD7E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:06:30 +0000 (UTC)
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D97AC
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 23:06:27 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2af1c884b08so36062251fa.1
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 23:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685340385; x=1687932385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1C27tR1D32rDokgoNpN/XlX8PxjtaCmAUIQOsW9e+Dg=;
        b=lHDuh9IwSH407x7/vRzlwq0hjpkP8Rb2yu9wptuaBjL+KJd4DvVK8VLEhhmA+GX+6Q
         G1azGO7JRAUPF5fIeYiIChNNunt6NUqHdgjDqzARXUsP/UXpH/W3ZPYxz4PS6e9q2KBE
         IFvecFl3EFNk9ZLCLkaWEqLncQxB//UkKAxrUgHcO9x8xkwRUVYj/hCSqi4+oPOshN0h
         yyAh8rhj/+mri+QN/UTx4EjGI+LKpPu6DvquJWyWkT9FoyMz+7KgO3/E/hen7Wq8SODO
         3qMXCpjWB0fyDpwJ0bcYBGimsxlXEg95SRrPpdf8Lqi1YOS8GtCckCet0U50PI/eAt/U
         048Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685340385; x=1687932385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1C27tR1D32rDokgoNpN/XlX8PxjtaCmAUIQOsW9e+Dg=;
        b=HD23btJMyAcVOsJXUqQU9RzLYq9i0jVpVYzynfHLvoL/MhLyNN/47OMk+OaRSbJOOv
         EpI9WBsluyXK5CccQLmHkUusgORkH7cfw7aMMtiqixObkB7Fho9lPEgecml4G7a9tCb5
         Lv9FIWw+0VmlTrCUNIvL3Y3fQ1z1qFK2efbu6rZd2KXxHYBH7ChOG94+w/X0LY09Ngvj
         ZZakEsg6rfNNRrkfiFiydv4vgeMYWRsasgApCITswUmRR/MVQFiTNABYzfLLlUYTfkCG
         5KJetbRvl12Dwoi8tF2DuSkK/EDfpZJjT0nqKFAqsiOH3BT1TBPTinkHLwF3AvejgfhH
         c7MA==
X-Gm-Message-State: AC+VfDxsjy3u9+U2qezauWGEfxfHZaeA2gQ03fWWsY7LQF3cndmWr5pv
	YTXbOSiWSrc4hLxfOc40S4AfXQ==
X-Google-Smtp-Source: ACHHUZ6bw9id1UY6mTID3C5HLVO2jCwdaQJ1hyxaGmO8a9avu9r1S2sRXoo8t+5MDWsyQh32F5W+zA==
X-Received: by 2002:a2e:8681:0:b0:2b0:62f0:a4db with SMTP id l1-20020a2e8681000000b002b062f0a4dbmr2793445lji.13.1685340385173;
        Sun, 28 May 2023 23:06:25 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x8-20020a2e8808000000b002a9f022e8bcsm2242377ljh.65.2023.05.28.23.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:06:23 -0700 (PDT)
Date: Mon, 29 May 2023 08:06:22 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Manish Chopra <manishc@marvell.com>
Cc: "kuba@kernel.org" <kuba@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Ariel Elior <aelior@marvell.com>, Alok Prasad <palok@marvell.com>,
	Sudarsana Reddy Kalluru <skalluru@marvell.com>,
	David Miller <davem@davemloft.net>
Subject: Re: [EXT] Re: [PATCH v5 net] qede: Fix scheduling while atomic
Message-ID: <ZHRA0Ef6l9YwVDfE@nanopsycho>
References: <20230523144235.672290-1-manishc@marvell.com>
 <ZG31gX7aVN1jRpn6@nanopsycho>
 <BY3PR18MB4612A5906D64C3DBACFAAECDAB469@BY3PR18MB4612.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB4612A5906D64C3DBACFAAECDAB469@BY3PR18MB4612.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 25, 2023 at 05:27:03PM CEST, manishc@marvell.com wrote:
>Hi Jiri,
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Wednesday, May 24, 2023 5:01 PM
>> To: Manish Chopra <manishc@marvell.com>
>> Cc: kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
>> <aelior@marvell.com>; Alok Prasad <palok@marvell.com>; Sudarsana Reddy
>> Kalluru <skalluru@marvell.com>; David Miller <davem@davemloft.net>
>> Subject: [EXT] Re: [PATCH v5 net] qede: Fix scheduling while atomic
>> 
>> External Email
>> 
>> ----------------------------------------------------------------------
>> Tue, May 23, 2023 at 04:42:35PM CEST, manishc@marvell.com wrote:
>> >Bonding module collects the statistics while holding the spinlock,
>> >beneath that qede->qed driver statistics flow gets scheduled out due to
>> >usleep_range() used in PTT acquire logic which results into below bug
>> >and traces -
>> >
>> >[ 3673.988874] Hardware name: HPE ProLiant DL365 Gen10 Plus/ProLiant
>> >DL365 Gen10 Plus, BIOS A42 10/29/2021 [ 3673.988878] Call Trace:
>> >[ 3673.988891]  dump_stack_lvl+0x34/0x44 [ 3673.988908]
>> >__schedule_bug.cold+0x47/0x53 [ 3673.988918]  __schedule+0x3fb/0x560 [
>> >3673.988929]  schedule+0x43/0xb0 [ 3673.988932]
>> >schedule_hrtimeout_range_clock+0xbf/0x1b0
>> >[ 3673.988937]  ? __hrtimer_init+0xc0/0xc0 [ 3673.988950]
>> >usleep_range+0x5e/0x80 [ 3673.988955]  qed_ptt_acquire+0x2b/0xd0 [qed]
>> >[ 3673.988981]  _qed_get_vport_stats+0x141/0x240 [qed] [ 3673.989001]
>> >qed_get_vport_stats+0x18/0x80 [qed] [ 3673.989016]
>> >qede_fill_by_demand_stats+0x37/0x400 [qede] [ 3673.989028]
>> >qede_get_stats64+0x19/0xe0 [qede] [ 3673.989034]
>> >dev_get_stats+0x5c/0xc0 [ 3673.989045]
>> >netstat_show.constprop.0+0x52/0xb0
>> >[ 3673.989055]  dev_attr_show+0x19/0x40 [ 3673.989065]
>> >sysfs_kf_seq_show+0x9b/0xf0 [ 3673.989076]  seq_read_iter+0x120/0x4b0 [
>> >3673.989087]  new_sync_read+0x118/0x1a0 [ 3673.989095]
>> >vfs_read+0xf3/0x180 [ 3673.989099]  ksys_read+0x5f/0xe0 [ 3673.989102]
>> >do_syscall_64+0x3b/0x90 [ 3673.989109]
>> >entry_SYSCALL_64_after_hwframe+0x44/0xae
>> 
>> You mention "bonding module" at the beginning of this description. Where
>> exactly is that shown in the trace?
>> 
>> I guess that the "spinlock" you talk about is "dev_base_lock", isn't it?
>
>Bonding function somehow were not part of traces, but this is the flow from bonding module
>which calls dev_get_stats() under spin_lock_nested(&bond->stats_lock, nest_level) which results to this issue.

Trace you included is obviously from sysfs read. Either change the trace
or the description.

>
>> 
>> 
>> >[ 3673.989115] RIP: 0033:0x7f8467d0b082 [ 3673.989119] Code: c0 e9 b2
>> >fe ff ff 50 48 8d 3d ca 05 08 00 e8 35 e7 01 00 0f 1f 44 00 00 f3 0f 1e
>> >fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56
>> >c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24 [ 3673.989121] RSP:
>> >002b:00007ffffb21fd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000 [
>> >3673.989127] RAX: ffffffffffffffda RBX: 000000000100eca0 RCX:
>> >00007f8467d0b082 [ 3673.989128] RDX: 00000000000003ff RSI:
>> >00007ffffb21fdc0 RDI: 0000000000000003 [ 3673.989130] RBP:
>> 00007f8467b96028 R08: 0000000000000010 R09: 00007ffffb21ec00 [
>> 3673.989132] R10: 00007ffffb27b170 R11: 0000000000000246 R12:
>> 00000000000000f0 [ 3673.989134] R13: 0000000000000003 R14:
>> 00007f8467b92000 R15: 0000000000045a05
>> >[ 3673.989139] CPU: 30 PID: 285188 Comm: read_all Kdump: loaded
>> Tainted: G        W  OE

[...]

