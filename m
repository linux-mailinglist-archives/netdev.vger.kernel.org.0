Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C022F28A3EE
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbgJJWzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732143AbgJJTkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:40:21 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D130BC08E88F
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:50:38 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id u74so6740973vsc.2
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+Eu+Npy2eRnNxLZJ28JIlRIMLPxL4I+0G8r9QAfYWo=;
        b=tL3JIAzDeAqk+vK3qzyMAn0pw0E9JptGc86xAyeyog6dtQJZbXfgFrnIcI2wjCMsWS
         uBhILbtz8+Wps4dlWwYjw5VjfLchX8nb55xKMGgELj71C47Ba6q7dpKYLHO1PUQQrhKe
         Zi/hz41cahg5d4d/S5iZw9ndUnX2msaxtJsRH74FIcIOkgQWiQQVPUvyH+iGG4Y2lPSS
         rkUzWGGBfv3g6n2bsvoYdCUO+URJAOceocCpu06AeF3eRvW/o4SwNBUM4oSYHfIhgq3a
         hVIl199r+fvV/F3J43Ktf/VNt4ksp5Agqo0pOkAJ7KJrmtAa1IiMUoALFM9TKl9KPl1J
         nAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+Eu+Npy2eRnNxLZJ28JIlRIMLPxL4I+0G8r9QAfYWo=;
        b=tvDCzmUeYSMSFg59pWqfkducCcGuxsI7Lz8sGW/gG7rP/9CTa/itdR4C42v6QoNfMl
         wE2wfNtMHalAfSxcaJ+u5PbLTD/HvoUC8pN02Lah+cuCWGEETZDrXOdwhe/Hml3VqsmF
         UeAB3A1hYGMagAo4G76rDYecD7BCOnjucHVm0K2KSdS4qZIVJXwYwMhQF0jOCyLFkmEq
         dUE5+nso0/QbElWf1bHGpqxQhRXtJvthq2u827hxO/wsZ/Hf34KT3HPemCwterVGEZNu
         4hTfK1SsHDoQW/tgpWc8FEgzdEzs/UHXJryQtDxiXPa34/8VWTJB8N9Pn2aV0DJpyaoy
         bpQw==
X-Gm-Message-State: AOAM531+GSCRZARPttwoMU68n3w4udXp6noKyc+UXrFvi1t0IupnByyf
        rLoxxzOR2joAf7YXOOdBJdaGn6ojxto=
X-Google-Smtp-Source: ABdhPJzAMDeM7CyLR/ByddHjRjnhUxLIVZq8BzkQB+1zlmPni3YvTegvsQyAdfNJcInLHiTJaMiDUQ==
X-Received: by 2002:a67:684e:: with SMTP id d75mr10825590vsc.28.1602348637178;
        Sat, 10 Oct 2020 09:50:37 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id l28sm645679vkm.0.2020.10.10.09.50.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 09:50:36 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id l6so5880723vsr.7
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:50:35 -0700 (PDT)
X-Received: by 2002:a67:684e:: with SMTP id d75mr10825547vsc.28.1602348635377;
 Sat, 10 Oct 2020 09:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20201008190538.6223-1-dwilder@us.ibm.com> <20201008190538.6223-2-dwilder@us.ibm.com>
In-Reply-To: <20201008190538.6223-2-dwilder@us.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 10 Oct 2020 12:49:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeGkAE5LxrYBWUYSACrNwt=e_xbmxV3HaRhM_5BiAY_oQ@mail.gmail.com>
Message-ID: <CA+FuTSeGkAE5LxrYBWUYSACrNwt=e_xbmxV3HaRhM_5BiAY_oQ@mail.gmail.com>
Subject: Re: [ PATCH v1 1/2] ibmveth: Switch order of ibmveth_helper calls.
To:     David Wilder <dwilder@us.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 3:06 PM David Wilder <dwilder@us.ibm.com> wrote:
>
> ibmveth_rx_csum_helper() must be called after ibmveth_rx_mss_helper()
> as ibmveth_rx_csum_helper() may alter ip and tcp checksum values.
>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
> Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>

Acked-by: Willem de Bruijn <willemb@google.com>

(for netdrv)

At first glance the two features sound independent, but this device
may pass mss information through the tcp checksum field. Hence that
must not get overwritten first.

"
        /* if mss is not set through Large Packet bit/mss in rx buffer,
         * expect that the mss will be written to the tcp header checksum.
         */
"
