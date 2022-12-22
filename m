Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F2F65444F
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 16:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbiLVP1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 10:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiLVP12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 10:27:28 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B3F2A53D;
        Thu, 22 Dec 2022 07:27:27 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id u9so5819045ejo.0;
        Thu, 22 Dec 2022 07:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nba1yEUQ4IspImoTxgBgulwRJGaLwUT3y2k3SAEhk2w=;
        b=CaCIlnKjNyZ4IyoUl+CgZj1LqeAv9MAUxcCT859S9HP2t5qJm9Z4T8ey94mFBH8ttk
         rRfDw3HtPeNHw+PyicPwUuEWNZKkQiijoLR4MytrrV+YDkcOxqCH9i9t9EWROX1eDlTG
         /16W1xVzGdK/R2S8hFNqPaspaZhRiVygxVhZHBzaz5uxAVfcNYlqeEzqvGFepV1bwBcY
         gACWjC5FWnUjp96e35P6klxU71HUaaF6DdRIGf/8S7Uir5/qtheBU+fiVk3o1j2uar9B
         DPmWS7QT7jqvjX4YY62nbAocHeExvpWxEGASrJ5QGIBtylTjaIhuR/h7N4r3j6oPyxVb
         cFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nba1yEUQ4IspImoTxgBgulwRJGaLwUT3y2k3SAEhk2w=;
        b=zsUbUOn5Bx6YFmwDnBfp5hhfSS3nIma79g/QvshFtSi5BJlISVqHhQ54DkNc0jMb8H
         vZzcjDVsAXcOUYip8yLIvHTkmcUavj57Mxu7zBzljBIvPpVlh9iZ//bPUA5g5q3o9zrL
         T6K46N7mLKE/LSYwT943Q6pcCryUxlIatIBqRb3/ZbQ01KuY+56RrJ3UN5D1soZtpta0
         0ozeittyN5AwMOcsOaTkCqDwHUfYElWYoynC6Gl/TvOyZkv44mlyKewacdFmob6szI/i
         8Bj4zVsbU7sPz+kUOvvS/SqYA+TbpfCjmxWADeOm7tX99p4DHn5Cf/o5Vxij6bsnPWkL
         qYOQ==
X-Gm-Message-State: AFqh2kqc6V+GAdLYJWrLNATFeDX/hSOw1H6CLriMZq2coWmpLgAncP8b
        O/arimf3O5459TPAHn2DzBBqJhkzT6QVXqeJRl+MDOLD18w=
X-Google-Smtp-Source: AMrXdXuKwHbEzVI/+VFZfpbd00bwED3WJ37vP8KCdY6EfPyam9i8faYgGpnmna4jNYZ3lVMwBm89LZRw3SLaZIlWnuM=
X-Received: by 2002:a17:907:6f13:b0:7ad:e161:b026 with SMTP id
 sy19-20020a1709076f1300b007ade161b026mr792609ejc.760.1671722846022; Thu, 22
 Dec 2022 07:27:26 -0800 (PST)
MIME-Version: 1.0
References: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
In-Reply-To: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
From:   David Rheinsberg <david.rheinsberg@gmail.com>
Date:   Thu, 22 Dec 2022 16:27:14 +0100
Message-ID: <CADyDSO7ui6cmhga-vjaxfw82gK6erDO54aYRWWqO4L6DKzNgug@mail.gmail.com>
Subject: Re: [PATCH 0/8] HID: remove some unneeded exported symbols from hid.h
To:     =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Thu, 22 Dec 2022 at 06:10, Thomas Wei=C3=9Fschuh <linux@weissschuh.net> =
wrote:
> Small cleanup to get rid of exports of the lowlevel hid drivers and to ma=
ke
> them const.
[...]
> Thomas Wei=C3=9Fschuh (8):
>       HID: letsketch: Use hid_is_usb()
>       HID: usbhid: Make hid_is_usb() non-inline
>       HID: Remove unused function hid_is_using_ll_driver()
>       HID: Unexport struct usb_hid_driver
>       HID: Unexport struct uhid_hid_driver
>       HID: Unexport struct hidp_hid_driver
>       HID: Unexport struct i2c_hid_ll_driver
>       HID: Make lowlevel driver structs const

Yeah, it makes sense to avoid exposing the structs.

Reviewed-by: David Rheinsberg <david.rheinsberg@gmail.com>

Thanks
David
