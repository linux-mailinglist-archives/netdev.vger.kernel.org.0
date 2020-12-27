Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D472E2FD5
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 05:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgL0Eeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 23:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgL0Eet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 23:34:49 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90264C0613ED
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 20:34:09 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id s21so4506863pfu.13
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 20:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=4XlqiPrBSBGdCpoVJYfXKGWOnswOFUCpcwoJ6ZKz/88=;
        b=Kda3SICCqFuc+ZJEsgdM+zxK3IUNNYQTazQNbkn3MOY+H+Aj9uYlJkrp5iYE8SaYgR
         h7bJMAVjiGLWpuLtI7VyPyD1XxuYCAsv4Yy3Z8ocKrzdpIytpGcoOZABKYYHHeU2/QgW
         xgGw8I488KXghu6KvgjedR+6uP+5yLVM75BS6XDetx4x4Ihr9C9DBQYbFiIH5u3SORwi
         2Nmt8dK/THI/hWMQtRL5aXwahXZd6sbwsltOvmFUHF2g2L50f7Qn73OxXbLfJt7vVVRm
         VXA4hAdNsX4C3dCbd5//X4hChQq+20xMILuoxG88ba7M0GAUV7qUl0NUOqx0iJupHbu9
         E1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=4XlqiPrBSBGdCpoVJYfXKGWOnswOFUCpcwoJ6ZKz/88=;
        b=I4IYuSzBgnn8LTfOb4d/M23qn6MDMulOYvpkvlknRC5KOdeA74Q7XCEuSR3Kj09Le7
         CY1M8uLXnYOTaJ1GMpWEfdWz6wQfHfx9Az4vd/HhvR8AVGw7nvNN1PRE+21f4AHJZRx2
         WgqHYJv+9WwFgfi3mbFxrjolY7dgKslsZDmyyqw60+RdCSNBjE7LkXESU8Tpb4p3Wr+N
         B66ZWWjuabSe8uAu890xWdKzTIcBjgsSNq9jqT5wMiuRcWiXtaKk4O6DqIPFpvdfxO6S
         gjqSgxk4wEl6dEjnqIxgO9sbcwD+3Zos3q7K70sGSR0xBe8jNS71ERfy1gZQ0Jr2w00w
         2TTQ==
X-Gm-Message-State: AOAM532wPdI1q5JI2acc0APlMqGNd8o2ncDR4ESca+h1lZUHaRGqMUak
        LMLYMaJYqaZQJX9HXNydp80=
X-Google-Smtp-Source: ABdhPJw9MKnOoVvEI5efTENyQfQIqhb8NYOGi3k+JN/LrPVLdAj0ucz6coUOFzNjCdFdKmnLUWzjWQ==
X-Received: by 2002:a65:4347:: with SMTP id k7mr27639198pgq.186.1609043648879;
        Sat, 26 Dec 2020 20:34:08 -0800 (PST)
Received: from [0.0.0.0] (ec2-18-162-40-218.ap-east-1.compute.amazonaws.com. [18.162.40.218])
        by smtp.gmail.com with ESMTPSA id w1sm9738194pjt.23.2020.12.26.20.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Dec 2020 20:34:08 -0800 (PST)
To:     mkubecek@suse.cz, netdev@vger.kernel.org
Cc:     shlei@cisco.com
From:   Bruce LIU <ccieliu@gmail.com>
Subject: "ethtool" missing "master-slave" args in "do_sset"
 function.[TEXT/PLAIN]
Message-ID: <d7196d65-c994-2e19-d41c-386a4957ac63@gmail.com>
Date:   Sun, 27 Dec 2020 12:34:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal Kubecek and Network dev team,

Good day! Hope you are doing well.
This is Bruce from China, and please allow me to cc Rudy from Cisco 
Systems in China team.

We are facing a weird behavior about "master-slave configuration" 
function in ethtool.
Please correct me if I am wrong....

As you know, start from ethtool 5.8,  "master/slave configuration 
support" added.
https://lwn.net/Articles/828044/

========================================================================
Appeal:
Confirm and discuss workaround

========================================================================
Issue description:
As we test in lab, no "master-slave" option supported.

========================================================================
Issue reproduce:
root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
ethtool: bad command line argument(s)
For more information run ethtool -h

========================================================================
Environment:
debian-live-10.7.0-amd64-standard.iso
Kernel 5.4.79
ethtool 5.10
Source code: 
https://mirrors.edge.kernel.org/pub/software/network/ethtool/ethtool-5.10.tar.xz

========================================================================
Troubleshooting:
root@raspberrypi:~# ethtool -h
ethtool version 5.10
Usage:
         ethtool [ FLAGS ] DEVNAME       Display standard information
about device
         ethtool [ FLAGS ] -s|--change DEVNAME   Change generic options
                 [ speed %d ]
                 [ duplex half|full ]
                 [ port tp|aui|bnc|mii|fibre|da ]
                 [ mdix auto|on|off ]
                 [ autoneg on|off ]
                 [ advertise %x[/%x] | mode on|off ... [--] ]
                 [ phyad %d ]
                 [ xcvr internal|external ]
                 [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]
                 [ sopass %x:%x:%x:%x:%x:%x ]
                 [ msglvl %d[/%d] | type on|off ... [--] ]
                 [ master-slave
master-preferred|slave-preferred|master-force|slave-force ]

root@raspberrypi:~# ethtool -s eth0 [double tab here]
advertise  autoneg    duplex     mdix       msglvl     phyad port
       speed      wol        xcvr

========================================
Review 5.10 source code:
ethtool.c line:5616

static const struct option args[] = {
{
.opts = "-s|--change",
.func = do_sset,
.nlfunc = nl_sset,
.help = "Change generic options",
.xhelp = " [ speed %d ]\n"
  " [ duplex half|full ]\n"
  " [ port tp|aui|bnc|mii|fibre|da ]\n"
  " [ mdix auto|on|off ]\n"
  " [ autoneg on|off ]\n"
  " [ advertise %x[/%x] | mode on|off ... [--] ]\n"
  " [ phyad %d ]\n"
  " [ xcvr internal|external ]\n"
  " [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
  " [ sopass %x:%x:%x:%x:%x:%x ]\n"
  " [ msglvl %d[/%d] | type on|off ... [--] ]\n"
  " [ master-slave 
master-preferred|slave-preferred|master-force|slave-force ]\n"
},

========================================
ethtool.c line:2912  do_sset function
There is NOT an "else if" to catch "master-slave" option, and the
options matched final else, and print an error message   "ethtool: bad
command line argument(s)\n""For more information run ethtool -h\n""

ethtool.c line: 3069

   } else {
exit_bad_args();

========================================
root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
ethtool: bad command line argument(s)
For more information run ethtool -h

Look forward to your reply.

Cheers!
Bruce Liu (UTC +08)
Email: ccieliu@gmail.com

-- 
Cheers!

Bruce Liu    (UTC +08)
Email: ccieliu@gmail.com
