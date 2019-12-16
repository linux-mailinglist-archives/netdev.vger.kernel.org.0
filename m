Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5456A121F0A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 00:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLPXjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 18:39:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44547 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLPXjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 18:39:03 -0500
Received: by mail-pl1-f196.google.com with SMTP id az3so5179996plb.11
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 15:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xNzIn5m2pfQ7QQAatktzcauxIEuZXIPBfI+4/mhujEs=;
        b=TkQOfJHMG9RkFv8jprF4SjoMxpsDQr+Zq3Ad8iU3gvwHBoGKe2koVSvuLlGN5oGWgm
         p2pgSB3osvdO6SELTFwaPJXA2xquFCdm+xO8ugqHBIQvnrCsgZjKxp2zsXI182ozXc0a
         1lc2nhcCOB9gky49SUb9oQeAq4q/Io6hUXCSGqBKqO6IFtJSMF9UCUorBIFqJRSmoBOO
         J/0+BvpM7c4lqtvIRUIBuOQtONW7N1WryuNjYqGN8Q+QVPYdpN69SMH88+is4HlM8GL6
         tkKQEz1Dl7HpfLuwtPwSV/RgJy/WOLRlupoafANmn3VyU6zzahQl4Y78qL1nJ2hdVjIa
         ygWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xNzIn5m2pfQ7QQAatktzcauxIEuZXIPBfI+4/mhujEs=;
        b=U0g0VHj8QUcoyhP4R3NewpbbqkGEt5PeZiUBVP5Z0ZaFpFk7+pQ27DzALIlKe/aoS3
         2VjAV+46aTrhKGI9bjCzNFe9btsxB3/0X+z8fFC+/bi0uFdziLRXzj40djkDI7jl3OZ0
         f+kYpL/je7osDm/vRNomXm6isndMVlOauwY0tkG5ydbWFpPFO1jI2cvtjcYS+tXthGvl
         ZO1CvP12DTjjIc3nejs9idiov3uzg3mWBgwqc8TnvLSFsCet50yOqXi5UBho6CQGCMx0
         eQ+PvO7hicvDR/0FdGgL7/BspfhetdkquaQmcQqrQUMMkjhfnv/kJ60XwfQQ6wJdlyyK
         xH5w==
X-Gm-Message-State: APjAAAUvc8nyZdbLsSV7J3obR4tZrjzdCXtpbfJ7HBoubDh9uZPMKxKI
        7mAlWx4WP+BlgV4jrPxp9/E=
X-Google-Smtp-Source: APXvYqwYhhv+KmIQvJqozl5/AAL6/VsiDcIXZZxUksZuq8vb5vxEx2uf6dn5ZqQm5+nIY+IOkL5biw==
X-Received: by 2002:a17:902:b589:: with SMTP id a9mr17586083pls.256.1576539543186;
        Mon, 16 Dec 2019 15:39:03 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id k12sm23105146pgm.65.2019.12.16.15.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:39:02 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH v3 0/2] net: stmmac: dwc-qos: ACPI device support
Date:   Sun, 15 Dec 2019 22:14:50 -0800
Message-Id: <20191216061452.6514-1-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Hi David

Version 3 of patches have fixes for comments from Jakub Kicinski.

------
Reposting the changes after rebasing since the merge window is open now
as per http://vger.kernel.org/~davem/net-next.html

These two changes are needed to enable ACPI based devices to use stmmac
driver. First patch is to use generic device api (device_*) instead of
device tree based api (of_*). Second patch avoids clock and reset accesses
for Tegra ACPI based devices. ACPI interface will be used to access clock
and reset for Tegra ACPI devices in later patches.

Thanks
Ajay

Ajay Gupta (2):
  net: stmmac: dwc-qos: use generic device api
  net: stmmac: dwc-qos: avoid clk and reset for acpi device

 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

-- 
2.17.1

