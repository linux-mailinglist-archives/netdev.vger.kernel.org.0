Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6C2C2933
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388737AbgKXOP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:15:56 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45684 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388732AbgKXOP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:15:56 -0500
Received: by mail-ed1-f65.google.com with SMTP id q3so20993129edr.12;
        Tue, 24 Nov 2020 06:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UV5dAkTriHZWlO3RZNeKzyPFwM32bAdjh6TvkdygNLU=;
        b=iZLbxa6RVLQ/eGQQUr6tQnhewRxsLVz4WSBlxhG9soMsum1SJoVaZdhJGEtcjxheWy
         wKRP+fOtvEqU+EJfCsWXjC7RYvy3kS5LnqjJzUQSNSLmK4WzvR8LAdxFqurb3w2bxk33
         yRhuG/jVKWo+sPpA+TwVR5c1YvHcBxu4zSCbriBREGg48/kZop2tJorj3d85y/G00+A5
         E2WYxUdfYpI6Tf8sHFrdbG2CYqfqdrirVbMvAtjN3FFF71ayC1Kh56qrV6MXdXXP8dpO
         yeB/Wuz5Ry+R2U47SmSo/nE6XBtHPmWyCgNF3Pizpqhi6POMLDCJT44s75O5C8SDQLy3
         ur+A==
X-Gm-Message-State: AOAM532ezJ3KEOBsXgGE/EO3LuQaogvj/9ape5QjJvktz2yTMkbjIbML
        1ypE4xEBAgyRSoZ47nJaKpCJyRcJqlE=
X-Google-Smtp-Source: ABdhPJwCPOnZBHCBRyU2XlZnrELUeUs/gXWwVcObQOhu4EYr+lV+0kodGtKSo/qsdsRfC8kU2V0qZA==
X-Received: by 2002:a05:6402:32c:: with SMTP id q12mr4192496edw.85.1606227350694;
        Tue, 24 Nov 2020 06:15:50 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id m3sm7039993edj.22.2020.11.24.06.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 06:15:49 -0800 (PST)
Date:   Tue, 24 Nov 2020 15:15:47 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: nfc: s3fwrn5: Support a UART interface
Message-ID: <20201124141547.GA3316@kozik-lap>
References: <CGME20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
 <20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
 <20201123081940.GA9323@kozik-lap>
 <CACwDmQDOm6PAyphMiUFizueENMdW3Bo5PvdP_VC_sfBEHc9pMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACwDmQDOm6PAyphMiUFizueENMdW3Bo5PvdP_VC_sfBEHc9pMQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 09:05:52PM +0900, Bongsu Jeon wrote:
> On Mon, Nov 23, 2020 at 5:55 PM krzk@kernel.org <krzk@kernel.org> wrote:
> > > +static enum s3fwrn5_mode s3fwrn82_uart_get_mode(void *phy_id)
> > > +{
> > > +     struct s3fwrn82_uart_phy *phy = phy_id;
> > > +     enum s3fwrn5_mode mode;
> > > +
> > > +     mutex_lock(&phy->mutex);
> > > +     mode = phy->mode;
> > > +     mutex_unlock(&phy->mutex);
> > > +     return mode;
> > > +}
> >
> > All this duplicates I2C version. You need to start either reusing common
> > blocks.
> >
> 
> Okay. I will do refactoring on i2c.c and uart.c to make common blocks.
>  is it okay to separate a patch for it?

Yes, that would be the best - refactor the driver to split some common
methods and then in next patch add new s3fwrn82 UART driver.

> > > +
> > > +static int s3fwrn82_uart_write(void *phy_id, struct sk_buff *out)
> > > +{
> > > +     struct s3fwrn82_uart_phy *phy = phy_id;
> > > +     int err;
> > > +
> > > +     err = serdev_device_write(phy->ser_dev,
> > > +                               out->data, out->len,
> > > +                               MAX_SCHEDULE_TIMEOUT);
> > > +     if (err < 0)
> > > +             return err;
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static const struct s3fwrn5_phy_ops uart_phy_ops = {
> > > +     .set_wake = s3fwrn82_uart_set_wake,
> > > +     .set_mode = s3fwrn82_uart_set_mode,
> > > +     .get_mode = s3fwrn82_uart_get_mode,
> > > +     .write = s3fwrn82_uart_write,
> > > +};
> > > +
> > > +static int s3fwrn82_uart_read(struct serdev_device *serdev,
> > > +                           const unsigned char *data,
> > > +                           size_t count)
> > > +{
> > > +     struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> > > +     size_t i;
> > > +
> > > +     for (i = 0; i < count; i++) {
> > > +             skb_put_u8(phy->recv_skb, *data++);
> > > +
> > > +             if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
> > > +                     continue;
> > > +
> > > +             if ((phy->recv_skb->len - S3FWRN82_NCI_HEADER)
> > > +                             < phy->recv_skb->data[S3FWRN82_NCI_IDX])
> > > +                     continue;
> > > +
> > > +             s3fwrn5_recv_frame(phy->ndev, phy->recv_skb, phy->mode);
> > > +             phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
> > > +             if (!phy->recv_skb)
> > > +                     return 0;
> > > +     }
> > > +
> > > +     return i;
> > > +}
> > > +
> > > +static struct serdev_device_ops s3fwrn82_serdev_ops = {
> >
> > const
> >
> > > +     .receive_buf = s3fwrn82_uart_read,
> > > +     .write_wakeup = serdev_device_write_wakeup,
> > > +};
> > > +
> > > +static const struct of_device_id s3fwrn82_uart_of_match[] = {
> > > +     { .compatible = "samsung,s3fwrn82-uart", },
> > > +     {},
> > > +};
> > > +MODULE_DEVICE_TABLE(of, s3fwrn82_uart_of_match);
> > > +
> > > +static int s3fwrn82_uart_parse_dt(struct serdev_device *serdev)
> > > +{
> > > +     struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> > > +     struct device_node *np = serdev->dev.of_node;
> > > +
> > > +     if (!np)
> > > +             return -ENODEV;
> > > +
> > > +     phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> > > +     if (!gpio_is_valid(phy->gpio_en))
> > > +             return -ENODEV;
> > > +
> > > +     phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> >
> > You should not cast it it unsigned int. I'll fix the s3fwrn5 from which
> > you copied this apparently.
> >
> 
> Okay. I will fix it.
> 
> > > +     if (!gpio_is_valid(phy->gpio_fw_wake))
> > > +             return -ENODEV;
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static int s3fwrn82_uart_probe(struct serdev_device *serdev)
> > > +{
> > > +     struct s3fwrn82_uart_phy *phy;
> > > +     int ret = -ENOMEM;
> > > +
> > > +     phy = devm_kzalloc(&serdev->dev, sizeof(*phy), GFP_KERNEL);
> > > +     if (!phy)
> > > +             goto err_exit;
> > > +
> > > +     phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
> > > +     if (!phy->recv_skb)
> > > +             goto err_free;
> > > +
> > > +     mutex_init(&phy->mutex);
> > > +     phy->mode = S3FWRN5_MODE_COLD;
> > > +
> > > +     phy->ser_dev = serdev;
> > > +     serdev_device_set_drvdata(serdev, phy);
> > > +     serdev_device_set_client_ops(serdev, &s3fwrn82_serdev_ops);
> > > +     ret = serdev_device_open(serdev);
> > > +     if (ret) {
> > > +             dev_err(&serdev->dev, "Unable to open device\n");
> > > +             goto err_skb;
> > > +     }
> > > +
> > > +     ret = serdev_device_set_baudrate(serdev, 115200);
> >
> > Why baudrate is fixed?
> >
> 
> RN82 NFC chip only supports 115200 baudrate for UART.

OK, I guess it could be extended in the future for other frequencies, if
needed.

> 
> > > +     if (ret != 115200) {
> > > +             ret = -EINVAL;
> > > +             goto err_serdev;
> > > +     }
> > > +
> > > +     serdev_device_set_flow_control(serdev, false);
> > > +
> > > +     ret = s3fwrn82_uart_parse_dt(serdev);
> > > +     if (ret < 0)
> > > +             goto err_serdev;
> > > +
> > > +     ret = devm_gpio_request_one(&phy->ser_dev->dev,
> > > +                                 phy->gpio_en,
> > > +                                 GPIOF_OUT_INIT_HIGH,
> > > +                                 "s3fwrn82_en");
> >
> > This is weirdly wrapped.
> >
> 
> Did you ask about devem_gpio_request_one function's parenthesis and parameters?
> If it is right, I changed it after i ran the checkpatch.pl --strict and
> i saw message like the alignment should match open parenthesis.

Yeah, but it does not mean to wrap after each argument. It should be
something like:

        ret = devm_gpio_request_one(&phy->ser_dev->dev, phy->gpio_en,
                                    GPIOF_OUT_INIT_HIGH, "s3fwrn82_en");

> 
> > > +     if (ret < 0)
> > > +             goto err_serdev;
> > > +
> > > +     ret = devm_gpio_request_one(&phy->ser_dev->dev,
> > > +                                 phy->gpio_fw_wake,
> > > +                                 GPIOF_OUT_INIT_LOW,
> > > +                                 "s3fwrn82_fw_wake");
> > > +     if (ret < 0)
> > > +             goto err_serdev;
> > > +
> > > +     ret = s3fwrn5_probe(&phy->ndev, phy, &phy->ser_dev->dev, &uart_phy_ops);
> > > +     if (ret < 0)
> > > +             goto err_serdev;
> > > +
> > > +     return ret;
> > > +
> > > +err_serdev:
> > > +     serdev_device_close(serdev);
> > > +err_skb:
> > > +     kfree_skb(phy->recv_skb);
> > > +err_free:
> > > +     kfree(phy);
> >
> > Eee.... why? Did you test this code?
> >
> 
> I didn't test this code. i just added this code as defense code.
> If the error happens, then allocated memory and device will be free
> according to the fail case.

Really, this won't work. It's kind of obvious why... You cannot use
kfree() on memory which is not allocated with kzalloc(). Or IOW, you
cannot use it if it is being freed by devm.

I doubt that you tested either this or the remove callback because if
you did test it, you would see easily:

[  145.018200] Unable to handle kernel paging request at virtual address ffffffed
[  145.025428] pgd = 67e71ef8
[  145.027774] [ffffffed] *pgd=6fffd861, *pte=00000000, *ppte=00000000
[  145.034052] Internal error: Oops: 837 [#1] PREEMPT SMP ARM
[  145.039278] Modules linked in: s5p_mfc exynos_gsc s5p_jpeg v4l2_mem2mem videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc
[  145.052987] CPU: 2 PID: 325 Comm: bash Tainted: G        W         5.10.0-rc3-next-20201113-00008-g62dd0da04641-dirty #79
[  145.063883] Hardware name: Samsung Exynos (Flattened Device Tree)
[  145.069971] PC is at devres_remove+0x9c/0xb4
[  145.074180] LR is at devres_remove+0x78/0xb4
[  145.078418] pc : [<c06a6134>]    lr : [<c06a6110>]    psr: a0010093
[  145.084666] sp : c6af7de0  ip : 00000001  fp : c2dd16e4
[  145.089861] r10: c2dd16c0  r9 : 60010013  r8 : c05894a8
[  145.095060] r7 : c058b128  r6 : c4bbc100  r5 : c2dd1410  r4 : c440d5c0
[  145.101564] r3 : ffffffed  r2 : c4bbc100  r1 : 60010013  r0 : c2dd16c0
[  145.108068] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  145.115260] Control: 10c5387d  Table: 46aa006a  DAC: 00000051
[  145.120979] Process bash (pid: 325, stack limit = 0x97d30bf6)
[  145.126696] Stack: (0xc6af7de0 to 0xc6af8000)
[  145.131039] 7de0: c4bbc100 c2dd1410 c058b128 c2dd1410 c440d5c0 c39a3400 c1305f08 c1348d28
[  145.139185] 7e00: 0000002b c06a6a54 c2dd1410 00000000 c440d5c0 c058ab94 c2dd1410 c06ccd04
[  145.147333] 7e20: c2dd1410 c19ab618 00000000 c19ab620 c39a3400 c06a1ff8 00000000 c2dd1524
[  145.155476] 7e40: c1c16800 c2dd1410 c1305f08 c1305f08 c1348d28 c39a3400 c6af7f78 c39a3410
[  145.163621] 7e60: c1c16800 c06a2624 c1305f08 c1305f08 0000000c c2dd1410 00000000 c1305f08
[  145.171769] 7e80: 0000000c c39a3400 c6af7f78 c39a3410 c1c16800 c06a29ec c2dd1410 c1305f08
[  145.179914] 7ea0: c12f0410 c06a0728 0000000c c4bbc140 00000000 00000000 c39a3400 c0381968
[  145.188058] 7ec0: 00000000 00000000 00000000 c5164640 0000000c 005e0da0 c6af7f78 c02d6120
[  145.196202] 7ee0: c038185c c02d5b70 00000001 00000000 c02d6120 00000000 00000000 c133c27a
[  145.204353] 7f00: c39f5690 c127b15c c116e588 c0b40ef0 c133c14f c3af4450 c39f5670 00000000
[  145.212497] 7f20: c3af4450 c018ea90 c120958c c39f5670 c3af4450 c116e588 c02f9988 c0197a00
[  145.220639] 7f40: c116e588 c0b40ef0 00000003 c1208ec8 00000000 c5164640 c5164640 00000000
[  145.228784] 7f60: 00000000 005e0da0 0000000c 00000004 00000000 c02d6120 00000000 00000000
[  145.236931] 7f80: 00000006 c1208ec8 c5164640 0000000c 005e0da0 b6fec680 00000004 c0100244
[  145.245077] 7fa0: c6af6000 c0100060 0000000c 005e0da0 00000001 005e0da0 0000000c 00000000
[  145.253222] 7fc0: 0000000c 005e0da0 b6fec680 00000004 b6f6310c b6f62c74 00000000 00000000
[  145.261370] 7fe0: 00000498 bef78290 b6e84ea4 b6ee2300 60010010 00000001 00000000 00000000
[  145.269555] [<c06a6134>] (devres_remove) from [<c06a6a54>] (devres_release+0x10/0x3c)
[  145.277340] [<c06a6a54>] (devres_release) from [<c058ab94>] (devm_pinctrl_put+0x20/0x44)
[  145.285388] [<c058ab94>] (devm_pinctrl_put) from [<c06ccd04>] (pinctrl_bind_pins+0xd0/0x27c)
[  145.293786] [<c06ccd04>] (pinctrl_bind_pins) from [<c06a1ff8>] (really_probe+0x90/0x4f0)
[  145.301842] [<c06a1ff8>] (really_probe) from [<c06a2624>] (driver_probe_device+0x78/0x1e0)
[  145.310069] [<c06a2624>] (driver_probe_device) from [<c06a29ec>] (device_driver_attach+0x58/0x60)
[  145.318936] [<c06a29ec>] (device_driver_attach) from [<c06a0728>] (bind_store+0x8c/0x100)
[  145.327074] [<c06a0728>] (bind_store) from [<c0381968>] (kernfs_fop_write+0x10c/0x230)
[  145.334960] [<c0381968>] (kernfs_fop_write) from [<c02d5b70>] (vfs_write+0xcc/0x524)
[  145.342658] [<c02d5b70>] (vfs_write) from [<c02d6120>] (ksys_write+0x64/0xf0)
[  145.349759] [<c02d6120>] (ksys_write) from [<c0100060>] (ret_fast_syscall+0x0/0x2c)
[  145.357377] Exception stack(0xc6af7fa8 to 0xc6af7ff0)
[  145.362395] 7fa0:                   0000000c 005e0da0 00000001 005e0da0 0000000c 00000000
[  145.370551] 7fc0: 0000000c 005e0da0 b6fec680 00000004 b6f6310c b6f62c74 00000000 00000000
[  145.378699] 7fe0: 00000498 bef78290 b6e84ea4 b6ee2300
[  145.383719] Code: e1a0000a e5942000 e1a01009 e5823004 (e5832000)
[  145.389795] ---[ end trace 769f050185612ec3 ]---

Please fix the double-free.

Best regards,
Krzysztof

