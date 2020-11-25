Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249492C3834
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgKYEnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgKYEnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:43:13 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DD9C0613D6;
        Tue, 24 Nov 2020 20:43:12 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id s27so1280675lfp.5;
        Tue, 24 Nov 2020 20:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=E4hb4wHZhBzjQ7cqxrZiiBsKOdlyx3ZfOpNyB4xO63E=;
        b=GWyVx/7k+S20N/EwAX+rlkw33fXii3XfJ96sHI4W56nlFiZjZmoRQO9Gg6AiGEj2ZD
         vd/aoWM2vbqyP/6Yk6Twq+AJ3yz/9iOxQiypKNq+BuhFpdAXHieDgQ8e9crGHYOg7fVh
         80daVbyYsUJBvM7TKul33EZ/9KPRRkjruYakgCrYVnXBqpGnH1Yfh1qJykFMI5Rkxglt
         xdyGWc8d9GoDZtyHxaoc4kkJ2Yh67a7uc0/NkOpxuaTrsixRTw8PNMO4YunxeP35ev2x
         qgWpOJK+3rhGFWbrF67NmgxDvbhfNDz2k6bFhMDsrHFTYa/qrpoaRgnDBaTZr0m0i2HG
         IzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=E4hb4wHZhBzjQ7cqxrZiiBsKOdlyx3ZfOpNyB4xO63E=;
        b=BCoNUaMgc0wMrUtXSKWDOcF7pwEHIG1ccRcSiEmAwshuZSRlzPsQkJQuubTMujyhJA
         g8ObJ5hR2TNnEjlUaVffbtpgu0YOWl7NI3J0ieVUcQ1j9Xp+avTISVMvMSS0+3gQuvSA
         /qp+9JvGH3MwMOsnZ1Ik9oavTOvp23zEsVi/9yTl6v0iGR0s7YAReLGUhNIWVNxB2TBS
         bR4l1hqnXFrWeRH/yFqDj2igaaujxDv7Jek053zTp56AlZp58uQt8TPXo/MbjkOnJ9wa
         LHmUfSE9CIVxFzryz6jmcinLaZjlyq0ZMcjQSrdY21qENy8BkeMHC2f9mjD4SjnDNPQQ
         XAIQ==
X-Gm-Message-State: AOAM530oRnDMBJ4gRrvs9TyTC6p2fTwRgU4f5hr99HvJiKeEjOV/ks9r
        Cl1m4DPV8FPfCR630cShDcBlflY3Dn4woC9a0BmoED8c
X-Google-Smtp-Source: ABdhPJyrqz7HfSUGc3zpXFkRDOAgxKowk1doVIhm5BrTJAQ4QIBgAgoPoV1fjn5hOF3fXFGvWsKukHZEHUcDADwUThs=
X-Received: by 2002:a19:f60e:: with SMTP id x14mr527380lfe.199.1606279391170;
 Tue, 24 Nov 2020 20:43:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9a:999:0:b029:97:eac4:b89e with HTTP; Tue, 24 Nov 2020
 20:43:10 -0800 (PST)
In-Reply-To: <CACwDmQC_ptQ+R1xLXRzZq=ewDsp2nA5v-Wb44yudcX92y=HQsA@mail.gmail.com>
References: <CGME20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
 <20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
 <20201123081940.GA9323@kozik-lap> <CACwDmQDOm6PAyphMiUFizueENMdW3Bo5PvdP_VC_sfBEHc9pMQ@mail.gmail.com>
 <20201124141547.GA3316@kozik-lap> <CACwDmQC_ptQ+R1xLXRzZq=ewDsp2nA5v-Wb44yudcX92y=HQsA@mail.gmail.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Wed, 25 Nov 2020 13:43:10 +0900
Message-ID: <CACwDmQCcP88jLmfRrsDAxOytHVv+tShfc7LnF4zO+F3UKmaybQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: nfc: s3fwrn5: Support a UART interface
To:     "krzk@kernel.org" <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20, Bongsu Jeon <bongsu.jeon2@gmail.com> wrote:
> On 11/24/20, krzk@kernel.org <krzk@kernel.org> wrote:
>> On Tue, Nov 24, 2020 at 09:05:52PM +0900, Bongsu Jeon wrote:
>>> On Mon, Nov 23, 2020 at 5:55 PM krzk@kernel.org <krzk@kernel.org> wrote:
>>> > > +static enum s3fwrn5_mode s3fwrn82_uart_get_mode(void *phy_id)
>>> > > +{
>>> > > +     struct s3fwrn82_uart_phy *phy = phy_id;
>>> > > +     enum s3fwrn5_mode mode;
>>> > > +
>>> > > +     mutex_lock(&phy->mutex);
>>> > > +     mode = phy->mode;
>>> > > +     mutex_unlock(&phy->mutex);
>>> > > +     return mode;
>>> > > +}
>>> >
>>> > All this duplicates I2C version. You need to start either reusing
>>> > common
>>> > blocks.
>>> >
>>>
>>> Okay. I will do refactoring on i2c.c and uart.c to make common blocks.
>>>  is it okay to separate a patch for it?
>>
>> Yes, that would be the best - refactor the driver to split some common
>> methods and then in next patch add new s3fwrn82 UART driver.
>>
>>> > > +
>>> > > +static int s3fwrn82_uart_write(void *phy_id, struct sk_buff *out)
>>> > > +{
>>> > > +     struct s3fwrn82_uart_phy *phy = phy_id;
>>> > > +     int err;
>>> > > +
>>> > > +     err = serdev_device_write(phy->ser_dev,
>>> > > +                               out->data, out->len,
>>> > > +                               MAX_SCHEDULE_TIMEOUT);
>>> > > +     if (err < 0)
>>> > > +             return err;
>>> > > +
>>> > > +     return 0;
>>> > > +}
>>> > > +
>>> > > +static const struct s3fwrn5_phy_ops uart_phy_ops = {
>>> > > +     .set_wake = s3fwrn82_uart_set_wake,
>>> > > +     .set_mode = s3fwrn82_uart_set_mode,
>>> > > +     .get_mode = s3fwrn82_uart_get_mode,
>>> > > +     .write = s3fwrn82_uart_write,
>>> > > +};
>>> > > +
>>> > > +static int s3fwrn82_uart_read(struct serdev_device *serdev,
>>> > > +                           const unsigned char *data,
>>> > > +                           size_t count)
>>> > > +{
>>> > > +     struct s3fwrn82_uart_phy *phy =
>>> > > serdev_device_get_drvdata(serdev);
>>> > > +     size_t i;
>>> > > +
>>> > > +     for (i = 0; i < count; i++) {
>>> > > +             skb_put_u8(phy->recv_skb, *data++);
>>> > > +
>>> > > +             if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
>>> > > +                     continue;
>>> > > +
>>> > > +             if ((phy->recv_skb->len - S3FWRN82_NCI_HEADER)
>>> > > +                             <
>>> > > phy->recv_skb->data[S3FWRN82_NCI_IDX])
>>> > > +                     continue;
>>> > > +
>>> > > +             s3fwrn5_recv_frame(phy->ndev, phy->recv_skb,
>>> > > phy->mode);
>>> > > +             phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN,
>>> > > GFP_KERNEL);
>>> > > +             if (!phy->recv_skb)
>>> > > +                     return 0;
>>> > > +     }
>>> > > +
>>> > > +     return i;
>>> > > +}
>>> > > +
>>> > > +static struct serdev_device_ops s3fwrn82_serdev_ops = {
>>> >
>>> > const
>>> >
>>> > > +     .receive_buf = s3fwrn82_uart_read,
>>> > > +     .write_wakeup = serdev_device_write_wakeup,
>>> > > +};
>>> > > +
>>> > > +static const struct of_device_id s3fwrn82_uart_of_match[] = {
>>> > > +     { .compatible = "samsung,s3fwrn82-uart", },
>>> > > +     {},
>>> > > +};
>>> > > +MODULE_DEVICE_TABLE(of, s3fwrn82_uart_of_match);
>>> > > +
>>> > > +static int s3fwrn82_uart_parse_dt(struct serdev_device *serdev)
>>> > > +{
>>> > > +     struct s3fwrn82_uart_phy *phy =
>>> > > serdev_device_get_drvdata(serdev);
>>> > > +     struct device_node *np = serdev->dev.of_node;
>>> > > +
>>> > > +     if (!np)
>>> > > +             return -ENODEV;
>>> > > +
>>> > > +     phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
>>> > > +     if (!gpio_is_valid(phy->gpio_en))
>>> > > +             return -ENODEV;
>>> > > +
>>> > > +     phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
>>> >
>>> > You should not cast it it unsigned int. I'll fix the s3fwrn5 from
>>> > which
>>> > you copied this apparently.
>>> >
>>>
>>> Okay. I will fix it.
>>>
>>> > > +     if (!gpio_is_valid(phy->gpio_fw_wake))
>>> > > +             return -ENODEV;
>>> > > +
>>> > > +     return 0;
>>> > > +}
>>> > > +
>>> > > +static int s3fwrn82_uart_probe(struct serdev_device *serdev)
>>> > > +{
>>> > > +     struct s3fwrn82_uart_phy *phy;
>>> > > +     int ret = -ENOMEM;
>>> > > +
>>> > > +     phy = devm_kzalloc(&serdev->dev, sizeof(*phy), GFP_KERNEL);
>>> > > +     if (!phy)
>>> > > +             goto err_exit;
>>> > > +
>>> > > +     phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
>>> > > +     if (!phy->recv_skb)
>>> > > +             goto err_free;
>>> > > +
>>> > > +     mutex_init(&phy->mutex);
>>> > > +     phy->mode = S3FWRN5_MODE_COLD;
>>> > > +
>>> > > +     phy->ser_dev = serdev;
>>> > > +     serdev_device_set_drvdata(serdev, phy);
>>> > > +     serdev_device_set_client_ops(serdev, &s3fwrn82_serdev_ops);
>>> > > +     ret = serdev_device_open(serdev);
>>> > > +     if (ret) {
>>> > > +             dev_err(&serdev->dev, "Unable to open device\n");
>>> > > +             goto err_skb;
>>> > > +     }
>>> > > +
>>> > > +     ret = serdev_device_set_baudrate(serdev, 115200);
>>> >
>>> > Why baudrate is fixed?
>>> >
>>>
>>> RN82 NFC chip only supports 115200 baudrate for UART.
>>
>> OK, I guess it could be extended in the future for other frequencies, if
>> needed.
>>
>>>
>>> > > +     if (ret != 115200) {
>>> > > +             ret = -EINVAL;
>>> > > +             goto err_serdev;
>>> > > +     }
>>> > > +
>>> > > +     serdev_device_set_flow_control(serdev, false);
>>> > > +
>>> > > +     ret = s3fwrn82_uart_parse_dt(serdev);
>>> > > +     if (ret < 0)
>>> > > +             goto err_serdev;
>>> > > +
>>> > > +     ret = devm_gpio_request_one(&phy->ser_dev->dev,
>>> > > +                                 phy->gpio_en,
>>> > > +                                 GPIOF_OUT_INIT_HIGH,
>>> > > +                                 "s3fwrn82_en");
>>> >
>>> > This is weirdly wrapped.
>>> >
>>>
>>> Did you ask about devem_gpio_request_one function's parenthesis and
>>> parameters?
>>> If it is right, I changed it after i ran the checkpatch.pl --strict and
>>> i saw message like the alignment should match open parenthesis.
>>
>> Yeah, but it does not mean to wrap after each argument. It should be
>> something like:
>>
>>         ret = devm_gpio_request_one(&phy->ser_dev->dev, phy->gpio_en,
>>                                     GPIOF_OUT_INIT_HIGH, "s3fwrn82_en");
>>
>>>
>>> > > +     if (ret < 0)
>>> > > +             goto err_serdev;
>>> > > +
>>> > > +     ret = devm_gpio_request_one(&phy->ser_dev->dev,
>>> > > +                                 phy->gpio_fw_wake,
>>> > > +                                 GPIOF_OUT_INIT_LOW,
>>> > > +                                 "s3fwrn82_fw_wake");
>>> > > +     if (ret < 0)
>>> > > +             goto err_serdev;
>>> > > +
>>> > > +     ret = s3fwrn5_probe(&phy->ndev, phy, &phy->ser_dev->dev,
>>> > > &uart_phy_ops);
>>> > > +     if (ret < 0)
>>> > > +             goto err_serdev;
>>> > > +
>>> > > +     return ret;
>>> > > +
>>> > > +err_serdev:
>>> > > +     serdev_device_close(serdev);
>>> > > +err_skb:
>>> > > +     kfree_skb(phy->recv_skb);
>>> > > +err_free:
>>> > > +     kfree(phy);
>>> >
>>> > Eee.... why? Did you test this code?
>>> >
>>>
>>> I didn't test this code. i just added this code as defense code.
>>> If the error happens, then allocated memory and device will be free
>>> according to the fail case.
>>
>> Really, this won't work. It's kind of obvious why... You cannot use
>> kfree() on memory which is not allocated with kzalloc(). Or IOW, you
>> cannot use it if it is being freed by devm.
>>
>> I doubt that you tested either this or the remove callback because if
>> you did test it, you would see easily:
>>
>
> Thanks to explain it in detail.
>
>> Please fix the double-free.
>>
>
> I understand it and will remove the kfree(phy).
> And i did the remove callback test using following echo command's
> parameters on raspberry pi.
> But i didn't see the error log like yours.
>
> Echo serial0-0 > /sys/bus/serial/devices/serial0/serial0-0/driver/unbind
>

Sorry to reply this email in a row.
I could see the log like yours when i changed the code at uart probe
functiom to make an error situation by force as below.
ret = -EINVAL;
     // s3fwrn5_probe(~~~

and i couldn't see the log when i removed the kfree(phy).
Thanks to mention it.


>> Best regards,
>> Krzysztof
>>
>>
>
