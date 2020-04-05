Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9319ED55
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 20:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgDESRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 14:17:25 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:42298 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbgDESRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 14:17:25 -0400
Received: by mail-il1-f195.google.com with SMTP id f16so12512052ilj.9
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 11:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WThap4R1TyY21kubOXGnRL2N4vgOg8TIPQfVde5q/3c=;
        b=NNyEodoGxtP0e+sB/M+qyKCuDHM8d3RNhM0CAVBWdq8HCnlAaxlNSSqes8VNz/Rgiq
         dm75SfWmBLQHuzf7Cmf0VTCcxbTqcEKferY5UbsjalSgpoWymvc/DMcPm2jrhh6IMDlj
         Gje7Uer7GAOf6TDYrU8Qnxkl7OFlSyD+s0FlXblX2GQMkkvNU+xcutmj8/4pukpdeL8w
         YTF96+xYY3zb2Dah5EOUk6AJw9kjLfdP/jjLWX9bqGxSloPOk1mdpBnIntcIFq92ih5/
         qK6ucHU1d0aM4UvkMSRqPsaakD0ULNHU4L4xN75QNQ9ZxqwgVF+LU+newl9GnHd40Ygl
         FcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WThap4R1TyY21kubOXGnRL2N4vgOg8TIPQfVde5q/3c=;
        b=EWVvl6jbQmOi1ENVD3QytG9OuBPwSNclOY7t3CSRiinN/16dXeC2NUcNt2YDrRp2OB
         hTcrzT/o4fAYuf9jbETC157yxx83gNgaQa5Fhdy/5qNvbKRfiXjFxCqGsZy4R7ZMl9fV
         1iec6Mn+l733TvzwUM+L/7Ax6+FFkjF6dOB/bMq67U4xZxn2lZ0q4af7Ixzy6JXM4Wq8
         q9nbKTi8rvw++WHIXDOBW326LXOPZW0gZtqeOsec9y4RuWM31yEJ4Sn32+1GKMnxOG2G
         sTIzfvVVcm+8OAepFos20PrJQE/P7NXsc4Q7TQjQJaq4sWX+elFXoncAYdVSEu5QScXG
         G3dw==
X-Gm-Message-State: AGi0PubbzVw59qbczm+zUVmWt8ya6i+LEErTAzINWV4iJbRmaEZWOjJP
        iWklz9Sw4m3BEIJZPJKTqPlIVpJw0lVeDf5LgBc=
X-Google-Smtp-Source: APiQypIpj2TzqqM89IAvMXfsVP9IQEsOHF9p/RuqsyoUY0zlFprRa7J5qD/R0Whuc56+D/ILJkaT0Nj2P1oR7GOwWuY=
X-Received: by 2002:a92:b606:: with SMTP id s6mr16834898ili.123.1586110644028;
 Sun, 05 Apr 2020 11:17:24 -0700 (PDT)
MIME-Version: 1.0
References: <CALW65jY8vvent1KmAnv2a9BTbmW5C8CHK0DpRRs73yk3L1RXLQ@mail.gmail.com>
 <20200405150915.GD161768@lunn.ch>
In-Reply-To: <20200405150915.GD161768@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Mon, 6 Apr 2020 02:17:13 +0800
Message-ID: <CALW65jZ8pKX5Ha-unvOnmptm1oPbStdC30wYjKj-Z9iEuGFXvw@mail.gmail.com>
Subject: Re: DSA breaks clients' roaming between switch port and host interfaces
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just tried. It did work but I think there are side effects, right?
