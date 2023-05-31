Return-Path: <netdev+bounces-6845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2C9718676
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8492D1C20D64
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD807171DE;
	Wed, 31 May 2023 15:35:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CA114289
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:35:30 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C85125;
	Wed, 31 May 2023 08:35:23 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f6d3f83d0cso62870325e9.2;
        Wed, 31 May 2023 08:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685547322; x=1688139322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gMMLKYR6LwwerFeeNHSp7kotCz7/hIxfivRXb+7S/jQ=;
        b=gXtM6WmPGHOFnqSQTqssenCj+2JZKiM5GNUQV/R01GBLBCiXsbQOXozk4sA0tpX7j0
         DvN19BpMXZfRg0MZI8IjP1ZG11JVfdRnBWYiN9lhWNUgE1cNhqtuCPM3nwa+jTZvPUtL
         CUPPCl1sbAMBhSdPseMEXkTNrs98m78zO+pJfGvM7Gedh3HvY2IE7JRBNgutfHoJeOAB
         o2S1tDxy0CUeaLj4Ynyu2bQtCmXiC2UFQRrnBEqknthbvZYRDRjoNVcatE/ljUuFetQ3
         1CbYX9rzJcSk2XJxG8EielgtUE/OwUqrAHluVrpcGOzuRhb2JuK0m09wL1fAsza11rEX
         tLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685547322; x=1688139322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMMLKYR6LwwerFeeNHSp7kotCz7/hIxfivRXb+7S/jQ=;
        b=AD481OEWt95yzYqh3frH4NOTrjQG0SePPJDhUFsjPNxTk4Qblxm27LxeCAO6pidAin
         U05KaSGSwzvPa8DhDJPGDzjyMZAEVcNlMFzTR+U2QJ3TMbhfLdl17aXEzsr8KWoD53Ip
         HGhT5mzBj/cIzyMVms4w83PGmCaNxcb4E6UhT20fFH70KEP8nqDL3e/gVBezGChUCQEp
         yw2NXCO358AGXeNMIidw8T54rWWFVSmsjHJJvROCEWhISASY6RNbioxaV5upwmBZta/S
         cmO3BCZo4r2T1i8OI/6jiN5FY9pncR5gYcC59cBy6cwKLSYND+if8ExIbEbsXi/NGbDv
         ucrA==
X-Gm-Message-State: AC+VfDw5ofJRPcrfnaiPCd8jAQXyIObKlSMjDAJACciLHagMVByDO00b
	IboFXejCP7ECGsuKDipiDlo=
X-Google-Smtp-Source: ACHHUZ7WUJhKvL9DJHfn5AidrIDIv2xMlD8cxZlHve4O5Z0/VdncAp/O5PtyLtTdhJCO9PMsK4oOrA==
X-Received: by 2002:a5d:5903:0:b0:307:8cf6:c2f1 with SMTP id v3-20020a5d5903000000b003078cf6c2f1mr4184943wrd.34.1685547321438;
        Wed, 31 May 2023 08:35:21 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s16-20020adfeb10000000b0030630120e56sm7167262wrn.57.2023.05.31.08.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 08:35:21 -0700 (PDT)
Date: Wed, 31 May 2023 18:35:19 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
Cc: "privat@egil-hjelmeland.no" <privat@egil-hjelmeland.no>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"andrew@lunn.ch" <andrew@lunn.ch>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del}
 methods
Message-ID: <20230531153519.t3go47caebkchltv@skbuf>
References: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
 <20230531151620.rqdaf2dlp5jsn6mk@skbuf>
 <426c54cdaa001d55cdcacee4ae9e7712cee617c2.camel@siemens.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426c54cdaa001d55cdcacee4ae9e7712cee617c2.camel@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 03:20:19PM +0000, Sverdlin, Alexander wrote:
> Well, it's not only about visible errors, but the driver also refused
> to install the FDB entries, so it's change in behaviour, not only
> cosmetics.

Ok, makes sense. Let's see what will happen with the backport - to be
honest I'm not completely sure. If you want to be completely sure I
didn't just throw a wrench into your plans, feel free to resend a v2
with just my review tag (dropping my Fixes tag), and you could also add
a comment stating that the ALR is VLAN-unaware while you're at it.

