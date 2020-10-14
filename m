Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F27328E450
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgJNQXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgJNQXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 12:23:08 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BFFC061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:23:08 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id x185so2445926vsb.1
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SZloh10poH4fOyUKzDEXRTeNmOd1f1V0a0onZ/tBRTA=;
        b=FgSKGZ4rRQ8ywztbq2FP4iOzAkiLH84fN5gz/NWoQKlXhjXQy1LE6EbmRltevU5nKx
         r7OFbiDZWWxze4l6Nu1c5BViCQvFlK94WILaRgMet8EQe4JLjQprANJezJptc5K9YR0/
         TsOFUwnrXOcXsuJWUQJoxNtqeQFkTuirhXDNIbnCqhOTtFinpzy9RGuPMZTqB5jQrWw/
         jEamJk5xAz6sa5mXIG0CEEaG4qFBTdMFlSCwq54FXJEHxTxhIt0SVK4YrwCocwqNuCPF
         nQ1v2d/BX+6t2HbciisfO4EMsfhP7ErDJ+5E9AAFh9qBImTeQjmChQ+upbqsnvAqk031
         uUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZloh10poH4fOyUKzDEXRTeNmOd1f1V0a0onZ/tBRTA=;
        b=IKGk39One1Wc4hlTG4KIvP4yKu1kAKNFhu+Z1B4MS/r5DNBs+4d/cQlR+Kd61ZXvnk
         Sr1q1h2kWd6r8ZcFqpd/dv8+Hh9NwErpWAfrs9XGl7Hoy8omnU/vOa/7QTZ0AcS+O+zz
         AtD8u5Zx9tT04P2XDalR5KsNZuN6jGzkaYcWzMGBJmQJISiKtolVlCSN7d+fKXN5vH6t
         +ez/tzAWTQlmIZnO5rPeFW6nPYRQe/F9rX/DzjYqukBkiUy0vS3tfmrOe1nhjBk4QMs2
         ZuL/4QQzsjdG0DCGnNiNxdkVCOGpLMZehSNY7Msg9E9TSobq36LJ7r11SJiyb8yTJ6XO
         y94Q==
X-Gm-Message-State: AOAM533T/HrgCPFk7vznlualM5bDPIAQY/CRRb/rpnx+KMUM32jgtZ3l
        EE4LWwDgtLaxInQobXOcdmwWsc4N5Sg=
X-Google-Smtp-Source: ABdhPJzfzkQ5LudDNVvgKTBzIoZ583tvci07Lt6EtEBTQDewWahkJB22cs8Fy9VrFu6u18Hsfx16QA==
X-Received: by 2002:a67:8e4a:: with SMTP id q71mr1516042vsd.1.1602692586940;
        Wed, 14 Oct 2020 09:23:06 -0700 (PDT)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id d135sm21647vka.8.2020.10.14.09.23.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 09:23:06 -0700 (PDT)
Received: by mail-ua1-f48.google.com with SMTP id r17so1301438uaf.2
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 09:23:05 -0700 (PDT)
X-Received: by 2002:ab0:76cd:: with SMTP id w13mr186696uaq.37.1602692585251;
 Wed, 14 Oct 2020 09:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201013232014.26044-1-dwilder@us.ibm.com> <20201013232014.26044-2-dwilder@us.ibm.com>
In-Reply-To: <20201013232014.26044-2-dwilder@us.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 14 Oct 2020 12:22:28 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeKrOMoOJjYqtgocou_705Kte4qkED9FtMJvVAAy3i3rQ@mail.gmail.com>
Message-ID: <CA+FuTSeKrOMoOJjYqtgocou_705Kte4qkED9FtMJvVAAy3i3rQ@mail.gmail.com>
Subject: Re: [ PATCH v2 1/2] ibmveth: Switch order of ibmveth_helper calls.
To:     David Wilder <dwilder@us.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 7:21 PM David Wilder <dwilder@us.ibm.com> wrote:
>
> ibmveth_rx_csum_helper() must be called after ibmveth_rx_mss_helper()
> as ibmveth_rx_csum_helper() may alter ip and tcp checksum values.
>
> Fixes: 66aa0678efc2 ("ibmveth: Support to enable LSO/CSO for Trunk
> VEA.")
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
> Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>

Acked-by: Willem de Bruijn <willemb@google.com>
