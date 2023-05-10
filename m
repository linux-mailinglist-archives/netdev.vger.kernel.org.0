Return-Path: <netdev+bounces-1467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9786FDD69
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27DC41C20D5E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B3212B6D;
	Wed, 10 May 2023 12:03:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3501F8C1C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:03:31 +0000 (UTC)
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225727AB8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:03:24 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-b9d8b2e1576so9211602276.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683720203; x=1686312203;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uCim+bkRSF5TeAVtzxeNUFktZnXXPuGjUTKfTMY/2Zw=;
        b=hngiIEi69KPKqZgfHKZ/ulUvZQKAnVcBbnckq1EvJ/1mSnqfuuToaM0vXAxZ7R0uTg
         Q8lUEWD0zaY+yeLkR7PgImLYRvGp66qjGiWb3q3xWdWoua7YhgIo53s3B80rcLQm+Hob
         OHkH/5CX6nmqRAk9atkUC8OmBmSZbC2rWo0u9YA76Ea+VtcUIk9yrlcGMA90zbiwbtZz
         305ZKd0sUQXlnvt7EiAfBdm/jFq0bfgOt2diaZA3ykgTyNLJfQhipLbN/Y/ekImi0grm
         hSz9a6jcUhe3Z1xjzLS94px2bQyl7ULTgJTTXMF0ameajZ8TRD9MSDbv028DAARzva2K
         WN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683720203; x=1686312203;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uCim+bkRSF5TeAVtzxeNUFktZnXXPuGjUTKfTMY/2Zw=;
        b=ByMfOL4CwJXxvL/5mr7kxsUkz5qfoobGrlfQOkS3PJB/WnMDvgYL15hjcoAN0XBjxR
         k/TXpL7sYxaFRFFYKkl2mFcJjZ7G5MFUWjeNtQcib5OI41z3k4aimD2ocQhhG1DNb77S
         BsrvpNdZBpuyEioj4R0tsSDaJCT1/yD2aZM9LqGq74X24946CjuczLrp1Y0BPDRTBvQL
         0FOUgYKOQUsCQS928UPu9ykAn+BPplL4jdqq2lrbkn9tOJFxyZKhtmrWBhETaZtPHPBZ
         VV/KVHkCRJnaOKNzHBHWyi0KQqjuUk23ghghY4qRj3Y6hHufmY8QJfIiJ6Qf8QBYK497
         KO6w==
X-Gm-Message-State: AC+VfDwtShmNXColDbIfKM4Tpv8wn0f736upOPu78x7jnxjb+zQQ83DN
	DcH2MEvHtby/Calhl+ANu/vvmAINgMMMwfZTwFqCcw==
X-Google-Smtp-Source: ACHHUZ4DynBs8EVJ3L4HnyeLVH08l/L//dmkuGhVuP6Mi4in/UDseRJCC7BoEc8Bms3kweOiDVlhdDtglocsYXjiisE=
X-Received: by 2002:a25:2612:0:b0:b9e:3bea:ebbb with SMTP id
 m18-20020a252612000000b00b9e3beaebbbmr16897621ybm.60.1683720203247; Wed, 10
 May 2023 05:03:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 10 May 2023 08:03:12 -0400
Message-ID: <CAM0EoMktXKNL5YejPOuUqVW_kLudzy5t5R0MvB=H6RKzLwV8dw@mail.gmail.com>
Subject: Anouncement: Netdevconf 0x17
To: people <people@netdevconf.info>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org, 
	lartc@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>, lwn@lwn.net, 
	Christie Geldart <christie@ambedia.com>, Kimberley Jeffries <kimberleyjeffries@gmail.com>, 
	Jeremy Carter <jeremy@jeremycarter.ca>, Felipe Magno de Almeida <felipe@expertise.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This is a pre-announcement on behalf of the NetDev Society so folks can plan
travel etc. Netdev conf 0x17 is going to be a hybrid conference.
We will be updating you with more details in the near future.

Date : Oct 30th to Nov 3rd
Location : Vancouver, British Columbia, Canada

Be ready to share your work with the community. CFP coming soon.

sincerely,

Netdev Society Board:
Roopa Prabhu,
Shrijeet Mukherjee,
Tom Herbert,
Jamal Hadi Salim

