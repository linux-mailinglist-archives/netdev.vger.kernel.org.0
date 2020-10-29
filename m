Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1E29DC13
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389845AbgJ2AVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgJ2AUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 20:20:31 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91938C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:20:30 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id v19so1320983edx.9
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tjZ0C47sBFE4E/dMNMwf9DAUHIodX8mtYvgDRoLI4EA=;
        b=YRSR+UuG72ciMnSbkIKW71fwluhc008uXS+zCtS9AHDFnFwQEIMMgP/YxKO2Dy1307
         WP7/iso+nlAS+anmA1lgk8lE/LiU6ECV1Z6zNFlM6NINwI35F0XF+CWuJQeINp59prgV
         jihocwVqHZpzzVYcqIAvrcvpd/gtQFCguDskE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjZ0C47sBFE4E/dMNMwf9DAUHIodX8mtYvgDRoLI4EA=;
        b=sfFj5wbJpCWIBJhBfsBucb4ne9at2cGs62yichWQx9YF9s5R5MIPVAwzHSD+aDfm8R
         kUJ86x0UMzewBgWUDtIQ0RpwVYH88LEOX2Qcr5nFq/8UpbS7qzbu8RH0ZqSiz1gKuxYu
         1I6+DOmDUTiEDKaShQdJUxuS/5QPatUDvN9X0M2Pjd5YROwXJzmHERAx71+9Xqp6EpK8
         5zPTalWbHQiy2t8hblNx5AkhXapv1hEjiTNHeZ6yS5knWotsTk57TiLa5RqQtWTzsLWp
         eccwn0rVpBFfT9SkR7clAZtXhZJfDxA9MIjukOV1uEr5iN5Ws4gJqmv4QUTVQHTxNlF4
         sAfw==
X-Gm-Message-State: AOAM530oKLqAEGICBj+cLLj0DDDn+w6q+RyrOSf/hrVzKWKv0oHholY9
        iyjy7yrI1USBdnA/SVbBwP8hDacLlbw/eg==
X-Google-Smtp-Source: ABdhPJysWTbk8EnVt3jhe7FD+kW1m2DIE9xH1CWsnZ8+b7F6bGTkr5QcyuGgR8JAjwumgY7CdUsHVg==
X-Received: by 2002:a05:6402:b72:: with SMTP id cb18mr1455133edb.129.1603930828995;
        Wed, 28 Oct 2020 17:20:28 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id i3sm576705edd.75.2020.10.28.17.20.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 17:20:28 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id g12so895819wrp.10
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:20:28 -0700 (PDT)
X-Received: by 2002:a19:c703:: with SMTP id x3mr502126lff.105.1603930383060;
 Wed, 28 Oct 2020 17:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201028142625.18642-1-kitakar@gmail.com>
In-Reply-To: <20201028142625.18642-1-kitakar@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 28 Oct 2020 17:12:51 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPX+fadTKLnxNVZQ0CehsHNwvWHXEdLqZVDoQ6hf6Wp8Q@mail.gmail.com>
Message-ID: <CA+ASDXPX+fadTKLnxNVZQ0CehsHNwvWHXEdLqZVDoQ6hf6Wp8Q@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: pcie: add enable_device_dump module parameter
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 3:58 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:
>
> The devicve_dump may take a little bit long time and users may want to
> disable the dump for daily usage.
>
> This commit adds a new module parameter enable_device_dump and disables
> the device_dump by default.

As with one of your other patches, please don't change the defaults
and hide them under a module parameter. If you're adding a module
parameter, leave the default behavior alone.

This also seems like something that might be nicer as a user-space
knob in generic form (similar to "/sys/class/devcoredump/disabled",
except on a per-device basis, and fed back to the driver so it doesn't
waste time generating such dumps), but I suppose I can see why a
module parameter (so you can just stick your configuration in
/etc/modprobe.d/) might be easier to deal with in some cases.

Brian
