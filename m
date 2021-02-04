Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F32310009
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBDWYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:24:20 -0500
Received: from mout.gmx.net ([212.227.17.20]:48143 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229511AbhBDWYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 17:24:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612477362;
        bh=DVeh3m8MwxKFCvgpbZDUyqnQ+k+2lP4FHgBsYhxjIXw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PbloUCoiy7/5pcQCJTyUEdDaXeUWxKFmD6o7aVM1psetqpkXsD0iupZFaxYfbZ8EC
         iEmbe7UNOH+9SIzKif0wX9jtH/YlFy41qXHfW3Dz40Mx5IcizVT3/xm6x8BSJjQjy1
         9ijt2OVg8n9RoTt2rq37L7G6FAbOBjUt3AXbABfY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [89.247.255.205] ([89.247.255.205]) by web-mail.gmx.net
 (3c-app-gmx-bap39.server.lan [172.19.172.109]) (via HTTP); Thu, 4 Feb 2021
 23:22:42 +0100
MIME-Version: 1.0
Message-ID: <trinity-efe6011b-4e34-4b7e-960f-bb78a3e44abd-1612477362851@3c-app-gmx-bap39>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, alex.popov@linux.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/vmw_vsock: fix NULL pointer deref and improve
 locking
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 4 Feb 2021 23:22:42 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <d801ab6a-639d-579f-2292-9a7a557a593f@gmail.com>
References: <trinity-64b93de7-52ac-4127-a29a-1a6dbbb7aeb6-1612474127915@3c-app-gmx-bap39>
 <d801ab6a-639d-579f-2292-9a7a557a593f@gmail.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:sqVNvfhEx6RFdces1XkIBOjiKBeydpvJtmXuBQ+5AMG3SJmCAvS/A9mDyzMLPWgOZUoZu
 tzAm1LgcPvy+qYv1inKxOx8vqo86prmUwv2zLCkUDOd7u03ltP9KLNYSOVrWYuBhuJ4BrP9SbGiB
 yjm2a+5IvpiKfWiDX/oKjDQDJg4MCKjC6cgvhoXqo9q2+Bi32spHye2c1Ifq+lUipKZZGhFllr87
 3mTODfg1XE8mmCj+V4DwQ2xOn8T3S0Pusqxj+WV0O1eyfz05BbcXQvyDR5+S7ma3WjpXe6b9Wsfx
 WY=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:df7JhOfyBfs=:DAhJGaRj/UVpsJF+89FTnA
 vutZ1//nPSkjoFXTv9szEoRA0VD0PelrAgm3JZulzY4miqls4fC8u0UlaG1WC3eAnDlKqJ4nX
 JYGVsoFb/BV1AAxjN+yVJsN1wg5NfKpI242bbXavRcFIrctd2msiDVOVCTuxG217cqCvpAmY9
 wowMHPVD28U0RVA7Vl9b9MpoDf7rNnYvW6Cu1KhSWH5J4vR0ToXdAzhyLxSxGDaQVVEmhUuwO
 v1SXsXT/gp2U16LsBt52QYZ/Xn8NwbQBxK+YciXwBXbMTa+p7EFDPeZK/4Nbk0HfJaYkF1kzj
 T4gWPpMoK87XRXtBS2czJDLoX8m26KyfXo5dEF0J0rGPsb/WX7o9GE63wkXSu3M/sOh4TY3p4
 Ki+ffZdLouy0fL6WG3vKUqmLigGQpzH8T8KIPVNwl2XUBPM/tFjHbEE8F2Z6KzwSBcWETV5bs
 EqOSPns+5irQJBjUVqcomd6/77Wmh/UoGkhumBMKxXeAAH86QP+uyX3ibT0AqLqiC46JNbucy
 ZAjemAh2SS5qXN2VB9BYTSB7j95MgbhIIHbqVnWBdZc9niSW9BdSo9KM3s8cVsU9kjnV6sFr1
 LQz3fUV1m7eWw=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We request Fixes: tag for patches targeting net tree.
>
> You could also mention the vsock_connect_timeout()
> issue was found by a reviewer and give some credits ;)

You're right, Eric Dumazet spotted the locking problem in vsock_cancel_timeout().
I am not too familiar how I should format my response to include it to the final
patch message, in case I should specifically format it, just let me know.
For now:

Fixes: 380feae0def7e6a115124a3219c3ec9b654dca32 (vsock: cancel packets when failing to connect)
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
