Return-Path: <netdev+bounces-3107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED28705800
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AC612812E4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AAC171A5;
	Tue, 16 May 2023 19:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE261290FE
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:53:38 +0000 (UTC)
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A15259
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:53:36 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-19619af9a02so7439113fac.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1684266816; x=1686858816;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aoBpSJcOhWO3rd6GByr0XDENY6wHuZMTjl51MQlf9RI=;
        b=cu5FsIKkZq5gNeygsH/wiq9//+7ShjMbrYIbuo0kBBS3xMdnkdiB7jIhxDQnARrHaa
         Nc3ElS+pE6KPNrNBVHVrJnc+YyBNdBmHZxhO4jj7XmpjJj2piE9ugtDnHOKWR+7/MlAO
         DZ+Ao7jpgEEnQXPJu+mkxZ0dAOAxw/7uC9Au2AEbG2ynHJheXpaF0FUzlEcLalTV9MiD
         t+xuQwvdjeWhHv+4p2tCEoEV2hFZ8tUWFy64ZXKRDgvpVLmoJdu0Ct2i+9awpl736tkG
         9kfTdkUGDPth1uMfg3+SR1flIkWuE8oUYIxNzGL6hdZOxkl2LwbvKI0WRDJFUsS8TUWr
         uP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684266816; x=1686858816;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aoBpSJcOhWO3rd6GByr0XDENY6wHuZMTjl51MQlf9RI=;
        b=XjtiMn7nSosrbU5mf4aq+U7jW7tVIeIn7djkf8DP/WNLynvrISavDw4TMHo8IoLkxQ
         7bO7bRifk4uN6cvfyFEopKXMfPjtwyfK20tv+IqwtApM+9WEByGCjQ3GNIMFBToBYIO5
         DNkoQ8Glm6qY3cyM6HSOId31kesMCHc3rBAAETsoq+FgXUB8XndI8T5c0uGVhgGR6LKD
         W3AU5AxUPtHLwds/iOUKsGo/gq1X4FNJItkUhfmjBini+Sqoc7TAhicwZmG7O8EdMS7q
         tgvpY96zuN50JcOETyjxvmX1Roxt6ATn6d9O2s+jy/kNUhB/5mfp00+J9RG/Cyey/MbT
         9pkw==
X-Gm-Message-State: AC+VfDw/1Z7Wb0oGQ5O5LcuIHUVotPR8QawrycGnjlR+nhwVe6gYmoYE
	75XSc7upnTcOiYvFBPwB9fOWg+GeIpBIS1aAwcH+Dn3xyQ4=
X-Google-Smtp-Source: ACHHUZ5wRaS7DQVs1M1ACMmYqL0TFPG0n4lnuKqd5BRkpe+cEAyrlaYthKrz9Q2bjBPEBPBhpMnUja8/+Lk0wLT/p44=
X-Received: by 2002:a05:6870:1841:b0:199:fe41:f734 with SMTP id
 u1-20020a056870184100b00199fe41f734mr901444oaf.37.1684266815832; Tue, 16 May
 2023 12:53:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Bernd Buschinski <b.buschinski@googlemail.com>
Date: Tue, 16 May 2023 21:53:25 +0200
Message-ID: <CACN-hLXbKQ8HYH5G05-t12tx++EmiY2J6VZvj_MzbLAVwayjRA@mail.gmail.com>
Subject: https://bugzilla.kernel.org/show_bug.cgi?id=217399
To: kuba@kernel.org
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I am sorry that I contact you directly, but I could not figure out how
to reply to the Kernel Mailing list thread.
https://lore.kernel.org/regressions/ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info/

I tried your suggested patch and reported my results to the Bugzilla
https://bugzilla.kernel.org/show_bug.cgi?id=217399

It works fine! Thanks for your work!

But is there anything else that I can help you with? Anything else to test?

