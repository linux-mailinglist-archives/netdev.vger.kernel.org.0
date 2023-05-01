Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F216F2EA0
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 07:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjEAFkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 01:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjEAFkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 01:40:05 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB8C1AD
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 22:40:03 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-2f7a7f9667bso1181682f8f.1
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 22:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682919602; x=1685511602;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pMOxR4rKM933jSPlO/bUqZhxWUqYk7fTqJQjyOB5BKc=;
        b=DxpAxH4tJHK/4z3uFsOHfhQ18+rZJjazgae01LR8xVjYsn5vAFMC3MJTRFh+KbZ39F
         zKM0bRI03tJldywE/AiHPrWiXapsrTDFTPJfUbyP7t5Rkm95HuaBzUW9OBxmsVJJJVrn
         DsWQzmyMQl0T6u6WWfWYaRbEqa9gIcnpMzOlZxnr+aj8KxfYQvEQ0ROC7sUYT2BtM/R+
         qgc2i9MH1dbha8ivHisvuN4q9WK92CydS8+/rG/slXN1T5j/G6AqupbfvRn3x4V7Mmz5
         LR5gb0/sz/yr4u/tIUAlfU5zt13U5Cu7PS0WB7rvz8mVUCkMeavPj6gN2Hw2i+9Qlckh
         zgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682919602; x=1685511602;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pMOxR4rKM933jSPlO/bUqZhxWUqYk7fTqJQjyOB5BKc=;
        b=kQ27zVZe86MGE9Ra4TiLt1a5k36YTof2p/g1PXC3u/TCEj8zqwiy4d2/tQJZSfl3rG
         8vJWv4Ju9tC3YaXzxyRCXgs7MnlSNYCS7WgWBcCiEr7LIMEKfyhs9w0wn3+Bvt7aEHOI
         G2ELj0MSiPeYFZ2HxKTVD3KdOO4+Wlnmlb3OhvSLkQDR2eNbaGRNqGLNqFGGPUiFMZws
         sN6DAkSdz2Q317ahmck/ourqahINGi07tQKxAuWoCixbVcIL8cMgsuRpA4BLY2kKAuus
         IPdVs8QAthOJylkCkepKlZYrQjsDevK1/8N5FvTjSEymD3/8r//XrdPD1D11A0MDGVGn
         bIpA==
X-Gm-Message-State: AC+VfDyygoCAq0WYiHG8kEnbPM0GKEDdhpAL631QVaSa72T/tR/Vxqms
        yUWDNgcTR2mQwvaDCmETjoA4K3xo7/nmlLaJLmqK83ETdSI=
X-Google-Smtp-Source: ACHHUZ7iwPJfsjdMkrVuyXl3Bhk66qbR4vOvOsEtAi0WVucmMjRruKrRQAj0wphKjpZjET/VT5l067xnbo47oyd0Z2c=
X-Received: by 2002:a5d:6291:0:b0:2f7:f6e:566 with SMTP id k17-20020a5d6291000000b002f70f6e0566mr9930517wru.31.1682919601492;
 Sun, 30 Apr 2023 22:40:01 -0700 (PDT)
MIME-Version: 1.0
From:   SANDEEP KUMAR <sandeepkumar2016000@gmail.com>
Date:   Mon, 1 May 2023 11:09:26 +0530
Message-ID: <CAOy+CXLjYTCKz=34b4c0n47B9Sf81xHbT=UrsYJj7eLKXHFYLQ@mail.gmail.com>
Subject: arp not getting resolved at the peer after route added on higher
 priority table 'tun0_table_rx' than 'local'
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

We have interface ens4 with 192.168.100.105 ip plumbed and also having
tun0 and tun0 having same ip 192.168.100.105 plumbed so if traffic is
coming to 192.168.100.105, we want to send to tun0. I have been able
to achieve this using the below configuration.However arp is not
getting resolved for 192.168.100.105 at the peer.What could be the
reason for this?

=E2=9D=AF cat /etc/iproute2/rt_tables
#
# reserved values
#
255     local
254     main
253     default
0       unspec
25 tun0_table_rx


Change the priority of lookup table
ip rule add preference 200 iif ens4 lookup tun0_table_rx
ip rule add preference 300 lookup local
ip rule delete preference 0

=E2=9D=AF ip rule show
200:    from all iif ens4 lookup tun0_table_rx
300:    from all lookup local
32766:  from all lookup main
32767:  from all lookup default

Route added on higher priority table tun0_table_rx
sudo ip r add  192.168.100.105 dev tun0 t tun0_table_rx

=E2=9D=AF ip r s t tun0_table_rx
192.168.100.105 dev tun0 scope link

Tcpdump on ens4 when ping from Peers so arp is not getting resolved.
=E2=9D=AF tcpdump -ni ens4 host 192.168.100.105
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens4, link-type EN10MB (Ethernet), capture size 262144 bytes
01:31:52.718238 ARP, Request who-has 192.168.100.105 tell
192.168.100.101, length 46
01:31:54.703204 ARP, Request who-has 192.168.100.105 tell
192.168.100.101, length 46
01:31:55.718265 ARP, Request who-has 192.168.100.105 tell
192.168.100.101, length 46


=E2=9D=AF ifconfig ens4
ens4: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.100.105  netmask 255.255.255.0  broadcast 192.168.100.=
255
        inet6 fe80::6dcf:494:4507:a146  prefixlen 64  scopeid 0x20<link>
        ether de:ad:ce:05:3e:8d  txqueuelen 1000  (Ethernet)
        RX packets 24746  bytes 2685240 (2.5 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 3198  bytes 307924 (300.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

=E2=9D=AF ifconfig tun0
tun0: flags=3D4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1500
        inet 192.168.100.105  netmask 255.255.255.0  destination 192.168.10=
0.105
        inet6 fe80::3ed9:95e8:b69a:62ec  prefixlen 64  scopeid 0x20<link>
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
txqueuelen 2000  (UNSPEC)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 21  bytes 1732 (1.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Thanks & Regards,
Sandeep Kumar
