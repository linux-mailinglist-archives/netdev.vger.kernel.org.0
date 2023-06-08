Return-Path: <netdev+bounces-9115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE657274FD
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 04:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBDEA1C20F1B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB9C110D;
	Thu,  8 Jun 2023 02:29:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F8710F3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 02:29:24 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBF41BF0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 19:29:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b00ecabdf2so106065ad.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 19:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686191362; x=1688783362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+orX+d9nyi1y/0XG1VdRCxy83cNaaCpaOJf7hZ69LL0=;
        b=fT0MHWknpQ7N6FKVImpyFkq3h975XRoTA2FcewRpeD9WsQiKztW2TFYUqX4Z5h9umu
         ukY0dFLlZwBAyP4Rs8aigNn6fg/tXqEE+K7FKmUnqCsEx7ltROsH5LzAkHqRK1KIkirM
         XlhlyGPA/EifKW/qMliMHzcAyLUDtztUpEoMnMv9GAhM1/szei9502NKGcSiQsqTZ7dp
         28w2e4NWrDKaaP8K4ZsMBd0nf3AsxswE9rHpvD5wtS3kA8Hrys5RCQ+g0Tq5Pzqi7oG8
         9HajVEvhDbOPMUrD298zC/4QuyP8NFRjPSNddMppukqSiLpUAWsoUINRr2sRMoY3dxSf
         fzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686191362; x=1688783362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+orX+d9nyi1y/0XG1VdRCxy83cNaaCpaOJf7hZ69LL0=;
        b=dYy0PO5WrJFrj7ManGrcUmvrRb9ecpQkyY8LfNVsazKIpGDZjROApOxdK2iFPe4cHT
         xsDXgTeLvI/mI8RTZZlSFYDAsV8cz1AkP5hc8lmBmOcie16tJ2KOxAI+XNK7ALbpZU1q
         bEiMC/opPjJ4ahl+tTzF83fPkgWTJ1l+xzssidLmschKSDCTgRJIhFnuZwSyVE6/rR2J
         n1lXdN07r3mcpJZDwinD9C4ESf9qgtdK/aPXANSR+ZAw45T4+SopgBZDYcBCfICtTuuS
         MS9dsZ4yAwp1/m2eX2hwAVXKWYHKo9DIGo5UQTGrlJDaiVs1Y8UJTiwgrMztDScuD5lt
         WSDQ==
X-Gm-Message-State: AC+VfDy0bH7JjguhUqSp/FedO9n3j7tUsotxbl8teyqlYFEE1I1nP0oR
	htBRuThDlIAWz1hfoY//DWuI2f8fqd04Ww==
X-Google-Smtp-Source: ACHHUZ6rjMZQ2rcApbSNXTvBegyQlQjdjmWa3gc6Wo9NS5K98c1pW6jvAEoCPBLXx48BtpK/uI/I8Q==
X-Received: by 2002:a17:903:32c7:b0:1b0:4c32:5d6d with SMTP id i7-20020a17090332c700b001b04c325d6dmr8846771plr.31.1686191362562;
        Wed, 07 Jun 2023 19:29:22 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jk2-20020a170903330200b001b02df0ddbbsm157813plb.275.2023.06.07.19.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 19:29:21 -0700 (PDT)
Date: Thu, 8 Jun 2023 10:29:18 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: shaozhengchao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org
Subject: Re: selftests/tc-testings cgroup.json test failed
Message-ID: <ZIE8/hwWta2+vWGH@Laptop-X1>
References: <ZIBT2d9U9/pdR/gc@Laptop-X1>
 <0e4a9752-ab3e-07cd-e030-45f230481d0b@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e4a9752-ab3e-07cd-e030-45f230481d0b@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 06:46:34PM +0800, shaozhengchao wrote:
> > I saw the matchPattern checks ".*cmp..." which is not exist with my tc output.
> > 
> > "matchPattern": "^filter protocol ip pref [0-9]+ cgroup chain [0-9]+.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff gt 10\\)",
> > 
> > So which tc version are you using? Am I missed something?
> > 
> Hi Hangbin:
> 	I upgraded iproute to 6.3.0 locally, and these test cases are
> successfully executed. My kernel version is 6.4.0 and OS version is
> ubuntu 1804 LTS. I am wondering if it had something to do with the OS?

Ah, I checked the source code and found my OS didn't enable
CONFIG_NET_EMATCH_CMP.

Thanks
Hangbin

