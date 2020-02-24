Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1752C16A5AA
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBXMDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:03:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40223 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgBXMDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 07:03:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so10062039wru.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 04:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zH3TYyTiXD6gnC/wQeI5aJJA5cN+AF8bn+o4XFHaVvY=;
        b=zsBaXdM8ZCd4ZWbZr7lrTtfas5klRDh5fHyEpYgDSRnbNUdlu0lP90ALZBVKImFUqS
         wBBmzxg+vOQVdtQjlP8tQVmg+6l69eA9DDUL2LFAnpqp4AZ1msoK02V7BG8LV5mqhpPd
         HfR4KN2yecRB/ZjB6uPW6xA7M51DO7Xw0YMvNuEK4zVCIih3odZSlfxXpPpLgCHen4hk
         bJZLjXiJ5i9oKHhNhtO9vwZ0mfXUN0wK4cUibDYIcVDXMZNx4SUi/MeTOnOqczHW1/fI
         2o4CKBcpY58CymXWwM1SSDzlyp3BlZRzdwdJKzlEC3eu/vghCy12qQmJWLIAtJOusSVx
         clGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zH3TYyTiXD6gnC/wQeI5aJJA5cN+AF8bn+o4XFHaVvY=;
        b=Nn225z1a3wgPASS0/g2kuEZHWwo7W81vS9KDffcY4Uex87u8TzPPI5mrnxgg3/b4+l
         M9zLXGL8FkUV+SPsped+Shc381JgzefBcCn+RJ5PZlY55pqx/84xtGiNnJ4HJHGdPCFm
         ojLtcd9TLl+/4nkpRcbVLkOWCwge36fH4hmOmBy45lyfysdtW5ZXTb7Ry3TWyHpyFfQr
         CmTcBng9ow45d0TtEMlgrlDIfjwKxgfTKRFGenkXQAinGYdVeCwtcT3mcrgqTUXOnSwB
         U4jIOMBVIZxbiZwrGrhND4/CZFaZXcQnkWTDpBj5udlKjezzj//aKslZpO/tMKk2iMp5
         M1wA==
X-Gm-Message-State: APjAAAVGLlZW0iyfyb3XhhGK/hqe0IIsauv5z3dTbIEmvo+yZdx0jPHa
        PfFRNmla8C7Ab8UsQ6VUHoC+HA==
X-Google-Smtp-Source: APXvYqw9W8JPCAtL6VtPX2tdVawfpDYSxIc0YERYZ2hA20ctJV2aOZZSr6yGWAHYDiTP6CFPQBhzWQ==
X-Received: by 2002:adf:f14b:: with SMTP id y11mr44241912wro.90.1582545810570;
        Mon, 24 Feb 2020 04:03:30 -0800 (PST)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id d18sm13076091wrw.49.2020.02.24.04.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 04:03:27 -0800 (PST)
Date:   Mon, 24 Feb 2020 12:03:26 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Jordan Hand <jorhand@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, dianders@chromium.org
Subject: Re: net/kgdb: Taking another crack at implementing kgdboe
Message-ID: <20200224120326.igxombbpuiqrjucx@holly.lan>
References: <ccd03920-375a-2e65-cc28-d00f3297cb67@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccd03920-375a-2e65-cc28-d00f3297cb67@linux.microsoft.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 04:33:48PM -0800, Jordan Hand wrote:
> Hey folks,
> 
> I have been scouring patches from around 2005-2008 related to kgdboe
> (kgdb over ethernet) and I am interested in taking a shot at getting it
> into the mainline kernel.
> 
> I found an implementation from Tom Rini in 2005[1] and an out of tree
> implementation[2].
> 
> So I have a couple questions before I dive in:
> 
> 1. Is anyone actively working on this? From lkml archives it appears no
> but I thought I'd ask.
> 2. Does anyone have an objection to this feature? From my reading it
> seems that the reason it was never merged was due to reliability issues
> but I just want to double check that people don't see some larger issue.

Like Jason said, I can't see any objections on the kgdb side but
integrating even with simple peripherals (UARTs for example) has it's
share of pitfalls so it may take a fair bit of work to make the net
developers comfortable!


Daniel.
