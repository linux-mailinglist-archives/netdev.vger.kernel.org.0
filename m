Return-Path: <netdev+bounces-1080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6B26FC19A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:22:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C61E1C20B02
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A35517AD9;
	Tue,  9 May 2023 08:22:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9D717AA8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:22:34 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13F9B4
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:22:26 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9661047f8b8so597992766b.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 01:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683620545; x=1686212545;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IASwr9LoMe+3O5jstjLyfRwwV6ZfMjZymt0sFmuMnW0=;
        b=o1SUkWGUXitCWnKDMEr2mKYzFQqUVFUGtKxqODrVJe03dR6TjFI7O9nq11TWpELE4o
         gjSdiYMAQD8lBiVzc0MAlGH/l3BXAlc8etYHSe4N2y9Z8+0CwW7Cbn3nDxNjgdY/nxA5
         C3y7b0cDUR9/A4J19t33oT8QymvXL6lNzwodBMzh47Gmh9NEa1Aw0LvV6PsFgeLkzfeq
         g/cCJ9m+mCKQBu3FWtjfvpxxXN29CSJpUwYJq+TsN2vfnRLllbpQAG4e3WywbOeWs08H
         EexO/OzHcxsGOiIhVsV9TPqUAKeTXKtXAgDmYT5TanoninzdXib2vdZtZFfmyFwfN5tC
         GsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683620545; x=1686212545;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IASwr9LoMe+3O5jstjLyfRwwV6ZfMjZymt0sFmuMnW0=;
        b=hGRRyCbfMp1ffbbu97QtoeHbguJ1ZOdSDUd0AtqpN6ziZcrNUR7l+0gr2ngFYsiSya
         S+DZKnTWj2Ggtii4jLdNBS3F5rRl9EunliGpRWDyKRXI2Hn8Xt4LwZwXsb4qfrhi9/SF
         XeeG6p3o2rrAEPVj8lezsRD/PuSS4UUvsT3djbGpMkBYED3gZuAqTCFmHr321nbIXecd
         XN7E+15egXjHdO+42lXHMNr3KJcdOUTltpEAqdbk49WOEoOLZ+ddyCHYKID7NrlqwBLT
         3OJmZXGfA3jnxThkboZ/x8CaStFRdmaERomx8SCP2yc+7D2W/xVRss0z4FjPdXWYMT+p
         5GvA==
X-Gm-Message-State: AC+VfDw/ytT75v2Txe/D6KAqSVbAxFfDE+N0+IijLFZoaimuhdpWzVkV
	oZ1cQkB5lKe3p09M0SZJp4I=
X-Google-Smtp-Source: ACHHUZ4ZTSlqcxWNRPXotkm1JJ+sOWQtk9y5wv079ckJi5atZZWXWPqLM51JxHpdup1JHKBw99rg6w==
X-Received: by 2002:a17:907:9405:b0:93b:5f2:36c with SMTP id dk5-20020a170907940500b0093b05f2036cmr11647431ejc.61.1683620545213;
        Tue, 09 May 2023 01:22:25 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id ew18-20020a170907951200b009660e775691sm1021241ejc.151.2023.05.09.01.22.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2023 01:22:24 -0700 (PDT)
From: Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Very slow remove interface from kernel
Message-Id: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
Date: Tue, 9 May 2023 11:22:13 +0300
To: Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Eric=20

I think may be help for this :


I try this on kernel 6.3.1=20

add vlans :=20
for i in $(seq 2 4094); do ip link add link eth1 name vlan$i type vlan =
id $i; done
for i in $(seq 2 4094); do ip link set dev vlan$i up; done


and after that run :=20

for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type vlan =
id $i; done


time for remove for this 4093 vlans is 5-10 min .

Is there options to make fast this ?


Same problem is when have 5-6k ppp interface kernel very slow unregister =
device.


best regards,=09
m.=

