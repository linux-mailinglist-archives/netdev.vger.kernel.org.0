Return-Path: <netdev+bounces-1651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEC46FE9DF
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FC901C20EBC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3828F5F;
	Thu, 11 May 2023 02:34:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420897FC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:34:26 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EE140C2
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:34:21 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1aad55244b7so61712865ad.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683772461; x=1686364461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EoX7/iePxH43BBwKkdASQ1YhO70d5hweDGNwTJusp/E=;
        b=zO+bxdsETNYRrnusgS9tQOpoM5kKR7FJVMmf1eN+iaqJWsTrxWzXch4+Lxt3itPT4G
         CdAEednXLIf9tzJvdImksgwZuaZwqMnkwr1f91mCf99EWOjaZUEPBVMW7UqNUs90+1F4
         uIM8T+KSpSOZhc3p5JeC1g3iDkQXUn4zyU+pOMcWDcwGAHYmlTLUKtbKWlq10xFLgVGA
         nIRbTDPsrIrLQr6bXCFE2+Se9wJa2Jrnqcw1WCR8PmzjBBQDS3CW2WL3aOISXre10wTj
         B1DvgpDDKCPh1GfbEwNWuFEDyUtIzM5jsWeVJhL4+OAtRIQeCrC6nEDpF/Qa2ahupqGd
         9aRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683772461; x=1686364461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EoX7/iePxH43BBwKkdASQ1YhO70d5hweDGNwTJusp/E=;
        b=CaBXIDYbiZfOMTxxq9QUGDhkMtqSvPwVK6QedfFVFJpR2wTBHffYppqwrTfkBdJ5pk
         cEJSaTF9GYwomFvcvRLfhgG0SZliHb4Gy09oab2uCmo+Hf95ZwspP26mMKoUknFscKVv
         kI6w1KL2lyCzTjnVsO9wjNvouBeDqYQp+c/dQ9RjBdH7gw8hDWnAueYvrcfkrPUyaZUh
         aMTgcyMJ84xmicGg4Ksc5uc+cgCDxvN7y7oAhDPaCTqgrVKvE2M4yqq17b6ByFQt0zzC
         jRYaJ8XHIi97O25apH4x85yk0bTAcouKT8uxfI5HgqHqRoD1MPRjfFdiCDDgZ+7bqitf
         UsgQ==
X-Gm-Message-State: AC+VfDyMkQhuowgZxgVM4C8mlLoFQ3uFN9j3BFVe9yhbfNxeRI7g9X02
	CzEPFS0zw2WjeSXTP5CvVaWN6Q==
X-Google-Smtp-Source: ACHHUZ7NDpzGIV+a1K6kNqYVo02xmZ4bhoeS8xZAJ6cFe+aQkv+A5sfaCUyytgOSnu8QwCebavjTQg==
X-Received: by 2002:a17:903:2498:b0:1ac:4027:fa16 with SMTP id p24-20020a170903249800b001ac4027fa16mr21130080plw.20.1683772461010;
        Wed, 10 May 2023 19:34:21 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y19-20020a170902b49300b001a1ccb37847sm4511656plr.146.2023.05.10.19.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:34:20 -0700 (PDT)
Date: Wed, 10 May 2023 19:34:19 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: zhaoshuang <izhaoshuang@163.com>
Cc: pawel.chmielewski@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH] iproute2: optimize code and fix some mem-leak risk
Message-ID: <20230510193419.1b19d587@hermes.local>
In-Reply-To: <20230511003726.32443-2-izhaoshuang@163.com>
References: <20230510133616.7717-1-izhaoshuang@163.com>
	<20230511003726.32443-2-izhaoshuang@163.com>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 11 May 2023 08:37:26 +0800
zhaoshuang <izhaoshuang@163.com> wrote:

> From: zhaoshuang <zhaoshuang@uniontech.com>
> 
> Signed-off-by: zhaoshuang <izhaoshuang@163.com>

Looks good thanks. Will wait for any other feedback

