Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6786F66BE9D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjAPNE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjAPNDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:03:34 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AD41449E;
        Mon, 16 Jan 2023 05:02:48 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v10so39413146edi.8;
        Mon, 16 Jan 2023 05:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DLfqfcaXi73VjYgQd4tjQ0KyH4dC5dOIZrX7XcLcA0g=;
        b=IfiUMchw8k9k8y7ay2ZB1xaHl/waySQNiTj8vQ1C7L9PsKb3YqbK2roDszZss0jZjm
         aUTuCnwZWymg9+ghh3Pk+VrNFgSvoRg7gDH6KRDU9XVFgQTkuvKPPx9Y6jPBReS1laEQ
         9d5XjhZYJNTGqAj1v9CAbN5QCQAySN1uayGUUuVRqmiMrWnhO6+F/qokjii+eacnuS0m
         ohH1Lc1UzNsrj8QA+JHc7i07NUvVERRAST/mTNb8tRmx244aUFPk3J6IVcxP+ZMxf/Qg
         P//4IQ7Dl9I4qJrdGoK4ul5OAMhRdEzSKnlChFXS/YkM4dsj9suawspz6QUtlaR86Qvt
         4osQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLfqfcaXi73VjYgQd4tjQ0KyH4dC5dOIZrX7XcLcA0g=;
        b=g9azNW6KKj75y3NkonU/L67HxafEqvbyzQOMAyhXKPaofZYMlbFdhQ27Q6S7PYDxix
         fhpriKP+QRsjFyust7pTSpF1ydvSFCqxfH6STF1u/D6c5I/oZZi+EWEBJ/h2sZHRLQtC
         p6/q4qPci6b9XvL56j6kuJ46X5guliTLsZRqE7T5avvc1WEoQ6fG2q68Bf3knfk2KVcD
         S8DYqApXEdKu+ZZ4AGD6W6bRExT2pU8f8R2lPIjArcgcPbXjv9F/ZEOWZOgGRF8ZYite
         Rs9sQd7MkPBJH/MqDH/IE3G2t8OXTABVfg7e73m0VRryPOUV7l/ewUKtO2YDkagQsulr
         O3yA==
X-Gm-Message-State: AFqh2koHVgESED0Oez1ii1hd7nvT8u4wTNRgFC3dTEZeQWl/qGIYlrCH
        wo/zz8It1bhW8NQMUVK8kaY=
X-Google-Smtp-Source: AMrXdXuhsVZtvI6rPoBrZ1WlOwVKZWCqvSltMxN/FmJe1tkmeH5ViGG3NZP7SVrPFy8uJYV/isPzSw==
X-Received: by 2002:aa7:c04f:0:b0:499:376e:6b31 with SMTP id k15-20020aa7c04f000000b00499376e6b31mr27826579edo.29.1673874166602;
        Mon, 16 Jan 2023 05:02:46 -0800 (PST)
Received: from skbuf ([188.27.185.68])
        by smtp.gmail.com with ESMTPSA id r24-20020aa7da18000000b004704658abebsm11535997eds.54.2023.01.16.05.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 05:02:46 -0800 (PST)
Date:   Mon, 16 Jan 2023 15:02:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     nikhil.gupta@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vakul.garg@nxp.com,
        rajan.gupta@nxp.com, richardcochran@gmail.com
Subject: Re: [PATCH v1] ptp_qoriq: fix latency in ptp_qoriq_adjtime()
 operation.
Message-ID: <20230116130243.ghtythag3og6745y@skbuf>
References: <20230116102440.27189-1-nikhil.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116102440.27189-1-nikhil.gupta@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikhil,

On Mon, Jan 16, 2023 at 03:54:40PM +0530, nikhil.gupta@nxp.com wrote:
> From: Nikhil Gupta <nikhil.gupta@nxp.com>
> 
> 1588 driver loses about 1us in adjtime operation at PTP slave.
> This is because adjtime operation uses a slow non-atomic tmr_cnt_read()
> followed by tmr_cnt_write() operation.
> In the above sequence, since the timer counter operation keeps
> incrementing, it leads to latency.
> The tmr_offset register (which is added to TMR_CNT_H/L register
> gives the current time) must be programmed with the delta
> nanoseconds.
> 
> Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
> Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---

Your patch breaks eTSEC1 [ and eTSEC2 ] on LS1021A.

Before:

root@black:~# ip link set eth1 up
root@black:~# [   54.321664] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Up - 1Gbps/Full - flow control off
[   54.331331] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

root@black:~# ptp4l -i eth1 -2 -P -m
ptp4l[57.231]: selected /dev/ptp0 as PTP clock
ptp4l[57.351]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[57.353]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[57.355]: port 1: link down
ptp4l[57.356]: port 1: LISTENING to FAULTY on FAULT_DETECTED (FT_UNSPECIFIED)
ptp4l[57.455]: selected local clock 001f7b.fffe.630228 as best master
ptp4l[57.458]: port 1: assuming the grand master role
ptp4l[57.464]: selected local clock 001f7b.fffe.630228 as best master
ptp4l[57.466]: port 1: assuming the grand master role
[   60.086366] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Up - 1Gbps/Full - flow control off
ptp4l[60.089]: port 1: link up
ptp4l[60.183]: port 1: FAULTY to LISTENING on INIT_COMPLETE
ptp4l[66.713]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
ptp4l[66.714]: selected local clock 001f7b.fffe.630228 as best master
ptp4l[66.715]: port 1: assuming the grand master role
ptp4l[102.753]: port 1: new foreign master 00049f.fffe.05f4ad-1
ptp4l[106.757]: selected best master clock 00049f.fffe.05f4ad
ptp4l[106.758]: port 1: MASTER to UNCALIBRATED on RS_SLAVE
ptp4l[107.763]: master offset -363290000824 s0 freq      +0 path delay       735
ptp4l[108.764]: master offset -363289992530 s1 freq   +8285 path delay       736
ptp4l[109.767]: master offset      -1648 s2 freq   +6637 path delay       736
ptp4l[109.768]: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[110.770]: master offset         -6 s2 freq   +7784 path delay       736
ptp4l[111.772]: master offset        491 s2 freq   +8280 path delay       735
ptp4l[112.773]: master offset        495 s2 freq   +8431 path delay       735
ptp4l[113.776]: master offset        342 s2 freq   +8426 path delay       731
ptp4l[114.778]: master offset        198 s2 freq   +8385 path delay       724
ptp4l[115.781]: master offset        100 s2 freq   +8346 path delay       722

After:

root@black:~# ip link set eth1 up
root@black:~# [  311.001924] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Up - 1Gbps/Full - flow control off
[  311.013236] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

root@black:~# ptp4l -i eth1 -2 -P -m
ptp4l[333.797]: selected /dev/ptp0 as PTP clock
ptp4l[333.916]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[333.918]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[333.919]: port 1: link down
ptp4l[333.919]: port 1: LISTENING to FAULTY on FAULT_DETECTED (FT_UNSPECIFIED)
ptp4l[334.012]: selected local clock 001f7b.fffe.630228 as best master
ptp4l[334.013]: port 1: assuming the grand master role
[  336.626213] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Up - 1Gbps/Full - flow control off
ptp4l[336.631]: port 1: link up
ptp4l[336.713]: port 1: FAULTY to LISTENING on INIT_COMPLETE
ptp4l[343.832]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
ptp4l[343.833]: selected local clock 001f7b.fffe.630228 as best master
ptp4l[343.834]: port 1: assuming the grand master role
ptp4l[344.873]: port 1: new foreign master 00049f.fffe.05f4ad-1
ptp4l[348.879]: selected best master clock 00049f.fffe.05f4ad
ptp4l[348.879]: port 1: MASTER to UNCALIBRATED on RS_SLAVE
ptp4l[349.888]: master offset 215392521359 s0 freq      +0 path delay       737
ptp4l[350.890]: master offset 215392529808 s1 freq   +8433 path delay       738
ptp4l[351.896]: master offset 215392529845 s2 freq +32767999 path delay       735
ptp4l[351.896]: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[352.897]: master offset 215359819000 s2 freq +32767999 path delay       731
ptp4l[353.899]: master offset 215326980590 s2 freq +32767999 path delay       731
ptp4l[354.900]: master offset 215294167912 s2 freq +32767999 path delay       729
ptp4l[355.902]: master offset 215261357366 s2 freq +32767999 path delay       725
ptp4l[356.905]: master offset 215228532618 s2 freq +32767999 path delay    -24741
ptp4l[357.907]: master offset 215195717627 s2 freq +32767999 path delay    -51970
ptp4l[358.909]: master offset 215162898062 s2 freq +32767999 path delay    -57014
ptp4l[359.912]: master offset 215130057602 s2 freq +32767999 path delay    -59714
ptp4l[360.915]: master offset 215097182978 s2 freq +32767999 path delay    -60737
ptp4l[361.917]: master offset 215064357344 s2 freq +32767999 path delay    -60783

I have forwarded you an internal email which gives more details about
how the 1588 block was integrated on the 3 eTSEC ports on LS1021A.
The general takeaway is: please don't break that SoC, and NACK for this
patch.
