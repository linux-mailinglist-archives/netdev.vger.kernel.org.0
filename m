Return-Path: <netdev+bounces-906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 747A16FB503
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A74F41C209DA
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5051D524E;
	Mon,  8 May 2023 16:25:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBB023CD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:25:54 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375003AB1
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 09:25:51 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64384c6797eso3821015b3a.2
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 09:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683563150; x=1686155150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMRspvRrnCiX2PGc3SiKh0fa94AnkU5LDoj0pGSvFHU=;
        b=0SDB6x2PHopDhbk1y+a0LH8gjtwXcG7OYClmL4E4hHEip2ovsG5tkhchFHrxTrrA9T
         UM7+QFe9A5ex3NK/62W8E0lJU5kX2Sve1UU5fuA2WwxrICcyYAnHmmD1hFERVABTGMjH
         dy4E1aj8COJMv+/RpDGzew2Aajd9ExACP2f9a1zsgM8H0XRRtRKp5GG7J4yqDiMqxldA
         BRtd54MZvy2wNOmWt4dXYX3k7OGf6v/O1W/IffhIu/N76qGRWhWcFsaxP3aumeb0PlNp
         Nwcqc8AsiKGSEWSGbxEF4mh/cvXYECcde7K5BUPQluuiFlDhwskEtpHL3Z/Sn609p1NU
         YWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683563150; x=1686155150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UMRspvRrnCiX2PGc3SiKh0fa94AnkU5LDoj0pGSvFHU=;
        b=Muope/T1QhI6IiYZcFkh/82Zl96nhaHi9lbPVqKATLXycfZzNy5XL8S1niEP8mlXZW
         iqcG3mMs7M0OhTqqmd64JjVTKJbOkLUYCGsczsAlrEiKEK+3PCTqzxjxHmpbWHhblDsd
         2gpESwnMMRg4kX39x1Ect2dsy073SMNJPDRLlSHWXmFr1oDyo7c3XtDQZgusj9BKy1n+
         OctKFE5huksc5NYbmZuOZWfJVvWOQeXbfupsvpYCw/MbcREjE1M49llu+5YnfGgalDsf
         DCJLLAsag8UbOKeYNO/kuk/GSHXqP4J//NBG3lxn2cw1g5IGNGDpcAYzm49FbvtK5Rnm
         SELA==
X-Gm-Message-State: AC+VfDysHlj2jPbbY4BpnFbZ770pNyIkTjptemfB/2tlwkKeuyJDYmmo
	CIBrCSfp44fsonYuo9dBWE6ak4vdFeBz4RPE5gqUFg==
X-Google-Smtp-Source: ACHHUZ6xW6/XcFMUPs+QzLs8J3iNk575OvzS5PxyJ5II6bUkrr8idBhdP+G4wYSZ5Ul/qBGSe63n/Q==
X-Received: by 2002:a05:6a00:2e1b:b0:63d:6744:8caf with SMTP id fc27-20020a056a002e1b00b0063d67448cafmr13482081pfb.26.1683563150656;
        Mon, 08 May 2023 09:25:50 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id s19-20020aa78d53000000b0063b86aff031sm164331pfe.108.2023.05.08.09.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 09:25:50 -0700 (PDT)
Date: Mon, 8 May 2023 09:25:48 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, huangml@yusur.tech,
 zy@yusur.tech, Jason Wang <jasowang@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "open list:VIRTIO CORE
 AND NET DRIVERS" <virtualization@lists.linux-foundation.org>, "open
 list:NETWORKING DRIVERS" <netdev@vger.kernel.org>, open list
 <linux-kernel@vger.kernel.org>, Hao Chen <chenh@yusur.tech>,
 hengqi@linux.alibaba.com
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device
 maximum MTU' bigger than 1500
Message-ID: <20230508092548.5fc8f078@hermes.local>
In-Reply-To: <20230508062928-mutt-send-email-mst@kernel.org>
References: <20230506021529.396812-1-chenh@yusur.tech>
	<1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
	<07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
	<20230507045627-mutt-send-email-mst@kernel.org>
	<1683511319.099806-2-xuanzhuo@linux.alibaba.com>
	<20230508020953-mutt-send-email-mst@kernel.org>
	<1683526688.7492425-1-xuanzhuo@linux.alibaba.com>
	<20230508024147-mutt-send-email-mst@kernel.org>
	<1683531716.238961-1-xuanzhuo@linux.alibaba.com>
	<20230508062928-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 8 May 2023 06:30:07 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> > > > I don't know, in any scenario, when the hardware supports a large mtu, but we do
> > > > not want the user to use it by default.  
> > >
> > > When other devices on the same LAN have mtu set to 1500 and
> > > won't accept bigger packets.  
> > 
> > So, that depends on pmtu/tcp-probe-mtu.
> > 
> > If the os without pmtu/tcp-probe-mtu has a bigger mtu, then it's big packet
> > will lost.
> > 
> > Thanks.
> >   
> 
> pmtu is designed for routing. LAN is supposed to be configured with
> a consistent MTU.

Virtio is often used with bridging or macvlan which can't support PMTU.
PMTU only works when forwarding at layer 3 (ie routing) where there is
a IP address to send the ICMP response. If doing L2 forwarding, the
only thin the bridge can do is drop the packet.

TCP cab recover but detecting an MTU blackhole requires retransmissions.

