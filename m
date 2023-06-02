Return-Path: <netdev+bounces-7398-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C0772006A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5116E1C20BF1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051DB182DD;
	Fri,  2 Jun 2023 11:30:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCAD8466
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 11:30:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0587718D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685705439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F00vpVMdWa9TR3+Nam4tbq5OQWssX8hYIk9OI5cMqFY=;
	b=NQ8VKrQ7SJtR4wo8UZYL/+D7ikqSD7BuQr3TdDmSHCiBCoGOpMfoZGTsnjegtgUVxpcYYb
	a/vP5qQKEnmyBgYnM0JNB3QZZGvVh/0j9nY9nsimK7qLu1KcNhfznp2dhnaNVbPtv0T0jT
	Gmb6DS2fHnn0Mu8aRDfpOWQHH+gAhRE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-e645v7RsNye_un-Nfm5BYw-1; Fri, 02 Jun 2023 07:30:38 -0400
X-MC-Unique: e645v7RsNye_un-Nfm5BYw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30c3ad3238bso912904f8f.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 04:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685705437; x=1688297437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F00vpVMdWa9TR3+Nam4tbq5OQWssX8hYIk9OI5cMqFY=;
        b=Pg0Nc5HIbzx2QvhV+RXGV1ooNo8x1BfXou+fDYZkqYY5rKrIoqS3OGzbasoHpv+kMl
         ax1nnw8RXoxhM67QwhJDVu6aS94hggCy4s2x+ZHnQMeQxi8SE+4K4IBCQ5RwvZEpBcWD
         UfQ8biZIsUEvHvn/32MaC4LsZ3ZzoxfXk8oLO3FdN8omSuAilTahaLdk8WdujWy0nvfD
         YlL0Fv72GtDn+XzDKqcHHsJygQ2mkKD27rYPm/bTeF8u+RHowP8UGPfZACrCQUNSbODG
         M2gO6oRcIpdNkNVJ5vcvx5b07GW9jjUkIW7yY6O4yagPrwy5cG3t8+srrGN+JCFMJh2c
         Rtig==
X-Gm-Message-State: AC+VfDzWOnm7hZsLymnsVEs22NrGnVeCsyQneFrlSpAd/jLQJbYUHyO1
	9G6TE6CDJf9XKJ8O5i1pXiNBsC2pGTgFYwoR0svG/S9oM97fYevwVUzvq3lBwG3v6GrUZa7fXNH
	clf8sGLGPJiLoF5vj
X-Received: by 2002:a05:6000:1141:b0:307:7f38:37f with SMTP id d1-20020a056000114100b003077f38037fmr3299569wrx.66.1685705437011;
        Fri, 02 Jun 2023 04:30:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ51q8bGzTk7RTQC1JX4flfHvzngWe3LU5wYEXOankGsD1jwSofiDuWc4F6Hnz+ZttjZWbaCmQ==
X-Received: by 2002:a05:6000:1141:b0:307:7f38:37f with SMTP id d1-20020a056000114100b003077f38037fmr3299553wrx.66.1685705436723;
        Fri, 02 Jun 2023 04:30:36 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id z9-20020a5d4c89000000b002fe96f0b3acsm1439241wrs.63.2023.06.02.04.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 04:30:36 -0700 (PDT)
Date: Fri, 2 Jun 2023 07:30:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH net 2/3] virtio-net: allow usage of vrings smaller
 than MAX_SKB_FRAGS + 2
Message-ID: <20230602072957-mutt-send-email-mst@kernel.org>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430131518.2708471-3-alvaro.karsz@solid-run.com>
 <20230430093009-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723043772ACAF516D6BFA79D4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230501061401-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723AA2ABCE91928BE735DEBD46E9@AM0PR04MB4723.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723AA2ABCE91928BE735DEBD46E9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 01, 2023 at 11:59:42AM +0000, Alvaro Karsz wrote:
> > First up to 4k should not be a problem. Even jumbo frames e.g. 9k
> > is highly likely to succeed. And a probe time which is often boot
> > even 64k isn't a problem ...
> > 
> > Hmm. We could allocate large buffers at probe time. Reuse them and
> > copy data over.
> > 
> > IOW reusing  GOOD_COPY_LEN flow for this case.  Not yet sure how I feel
> > about this. OTOH it removes the need for the whole feature blocking
> > approach, does it not?
> > WDYT?
> > 
> 
> It could work..
> 
> In order to remove completely the feature blocking approach, we'll need to let the control commands fail (as you mentioned in the other patch).
> I'm not sure I like it, it means many warnings from virtnet..
> And it means accepting features that we know for sure that are not going to work.
>

Well they will work yes? just with an extra copy.

-- 
MST 


