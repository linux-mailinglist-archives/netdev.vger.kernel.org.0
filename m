Return-Path: <netdev+bounces-1324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BF66FD55D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9185A1C20CC0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6628264B;
	Wed, 10 May 2023 04:50:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CECD63E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:50:29 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE984218;
	Tue,  9 May 2023 21:50:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64115eef620so47461639b3a.1;
        Tue, 09 May 2023 21:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683694224; x=1686286224;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjvF0okmkO6bRnSuK5692kJbO2O9eLlNpM3QSK5raGA=;
        b=Z1VR9OCE3JfLqABa9qplnc18A4vve7+jhk6ZZRLyvX6nhH9TgzGWcOxVy2KE7+RHDB
         IFxpICz2YqFTIB2mJjq85MD/6FtCgvLnmn+b9wuUFGQeMIYOIiKFy/2xFG/3ci6lE8YM
         QF5EgixnPPNKrvU2yg+LnC/NA+bUCaoPOh5z5uiWfRlKDs1yOuP6CcLvf+fsdNvS+mbH
         bhsZ7TejvQW/8HDTCyKr1J9YjPmJ9EksOiMyNScXdyanLpRxgiRXLs0gyuD0iJ6MbEPH
         SDHMIOMRt6SXRoyg72j5Blo4wnwFrxaLFxVmKEuY6ac1HW9hvIp/fNKR53cWHf3TyqvH
         FvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683694224; x=1686286224;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fjvF0okmkO6bRnSuK5692kJbO2O9eLlNpM3QSK5raGA=;
        b=CO7iLwnqmyVfI+Jc4H185r/V6Y2R5nsEEt666SovnMjzBDWS5M1UCw68RHVoaMgDuC
         jwvVSCcQB0Iy0j8Kuak4b7rkHzI5zAO5JEl080y30vYBcJbDaWKQV+G5FcsTXgtxE3sJ
         78fOjAwkX5ybKtR67fX9TaiFFw9Xl+TSrMupW/Vt9xGfxCaZT3MVC8pPwoIxMkbfYcv0
         /Lbtyxi/WBT0VWFkM2XDPLHeKpDGWyH9SX7lORLW6Fm8NGYuXrk04d0rmNRIKs3pMK1l
         9KG5ux3hLD+UEQdSpzwpmkKKbHUj8WyGgZzTNOP+w5udJoAJrXYalkGUhQoD9SGO/LpP
         vxUA==
X-Gm-Message-State: AC+VfDy7lSKrqeYIGsNc2vYrmW5q6+3dxVRgOSu1czDVmgX6KWZ97p3s
	tRrQCMwRmgnAR/LtTrxZSNY=
X-Google-Smtp-Source: ACHHUZ5GguK/UatlKScuuJ1FXRgLeUPfVlIBVrcz7ePqO0X62Qzo3Wnjdr2zlHi5SgqKj6owWZ3pSA==
X-Received: by 2002:a17:90a:feb:b0:24e:463c:c4a7 with SMTP id 98-20020a17090a0feb00b0024e463cc4a7mr24450607pjz.15.1683694224295;
        Tue, 09 May 2023 21:50:24 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-2.three.co.id. [116.206.28.2])
        by smtp.gmail.com with ESMTPSA id ot5-20020a17090b3b4500b002508d73f4e8sm4404727pjb.57.2023.05.09.21.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 21:50:23 -0700 (PDT)
Message-ID: <acf162e6-3dc2-6976-bceb-fa82b5e7b2c2@gmail.com>
Date: Wed, 10 May 2023 11:49:49 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To: Linux Regressions <regressions@lists.linux.dev>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Linux Intel LAN Drivers <intel-wired-lan@lists.osuosl.org>,
 Linux Networking <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: e1000e - slow receive / rx - i219-LM (Alder Lake)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I noticed a regression report on bugzilla [1]. As many developers don't
take a look on it, I decided to forward it by email. To reach the
reporter, though, you need to log in to bugzilla.

Quoting from the report:
>  Scott Silverman 2023-03-03 17:55:10 UTC > When running kernels 5.15 and newer, poor rx speeds are observed on Alder Lake i219-LM (8086:1A1C) on a Dell Precision 3260 Compact.
> 
> To Reproduce:
> Using iperf3 from the system under test:
> `iperf3 -c <server on local LAN> -R`
> 
> Under kernels 5.7-5.14 (inclusive) performance is near line rate, ~990 Mbps.
> From kernels 5.15 through 6.2 performance is approximately 10-20 Mbps.
> 
> Also of note, the issue doesn't present with servers over the internet (i.e. higher latency links). Over a link with a latency of approximately 20ms I was able to achieve about 600Mbps.
> 
> Interesting workaround, on affected kernels (5.15+) I am able to resolve the issue if an additional device is installed into the systems PCIe slot (tested with an Intel i210 NIC (not connected to LAN) and an Nvidia Quadro P620 GPU).

See bugzilla for details.

To the reporter: It had been great if you also test the latest mainline
(6.4-rc1) to see if this regression has been already fixed.

Anyway, I'm adding this to regzbot:

#regzbot introduced: v5.14..v5.15 https://bugzilla.kernel.org/show_bug.cgi?id=217120
#regzbot title: e1000e performance drop (slow receive/rx) on i219-LM (Alder Lake)

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217120

-- 
An old man doll... just what I always wanted! - Clara

