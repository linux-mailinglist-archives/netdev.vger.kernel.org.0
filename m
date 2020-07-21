Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34592287C9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgGURvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgGURvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:51:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0161DC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:51:15 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id t11so11062248pfq.11
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=3Ow1TQczWOHzR3AEy12qghXvrS526djoT6kkYLP3bw0=;
        b=at3mmJ2vrzMYZlHdxkz79ZtYHSZYLwHu2pVROvS/cQgxUJ/1AVClM+dUB7/ZrW8oOu
         TPkzI0GrqtOLcVGFG7BqeQT/U3fNePZ0MNAfKKNExYv1P6Ve9fVQn9sf7nMzgAeE7A33
         TGLFGfH25GxIvO2BFluBZjyiGgIn9/WMas6rPR5UVtsC38Yynr0GcG0p1BdhvB4iVmGm
         4nWE1GcS7qJQhj7QQ+fJRr8julwr5nRoFT+HTu0TOzJeCyq8iww7DafhmbyCYAATy9YB
         pyqZaNaQc3qGx7aIXNyYOdGR+6EYGQ4GmVxupI7i/z4zqJ4I1YNKkRAaKK6YLZG1AAlJ
         1SaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3Ow1TQczWOHzR3AEy12qghXvrS526djoT6kkYLP3bw0=;
        b=OPKsJ77wDDaaLq0LCMKPvDOfU4Wr/lcKOgRbL1IDY64dY+rz6P+1zhwQdMyDOnC3Mz
         TREka/ee0XSyCaVAXAAcSKhnJngUb496TD84PHnzWk+6xrBXmbgjLMFFJoTF4oZwSWLT
         NFDSwVg1yepYWrYe0GApUENjWLmfRPrDNOrgzUW+omCMa8IZPDd80t0emdqDufg0BFRj
         bP/1M5FV7ksFWAxXrGvx5ncKn6d0gSOScyGQSFkXmNgssig8HWjif0bJG7Tz8uhdkRaz
         xCuf55YNphydz/OKw4ePDTAkpUV1b3GREItPPkKkD9dBevwv8RQJn0m9tm4hEzdQM4/j
         C2IA==
X-Gm-Message-State: AOAM530eSB2uNpZS4q2VcqC2s7YGW7S4ELACZ2DrfGof43JWKgq68lX3
        X0wQ+z6eKL3yKh1OW/g/ZSNY30otcqo=
X-Google-Smtp-Source: ABdhPJye/yozyIOU7+xzc7tNDZBUTuvXk/GCyG5zu751PeVMaUO/GJNTw7LtzW5nLr1jNn/wY/Mu2g==
X-Received: by 2002:a63:4b0f:: with SMTP id y15mr22820200pga.72.1595353874563;
        Tue, 21 Jul 2020 10:51:14 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id n15sm3942956pjf.12.2020.07.21.10.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:51:14 -0700 (PDT)
Subject: Re: [PATCH v2 net 0/6] ionic: locking and filter fixes
To:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200721174619.39860-1-snelson@pensando.io>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <10d916d0-ce8c-2069-3874-a81c083178eb@pensando.io>
Date:   Tue, 21 Jul 2020 10:51:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721174619.39860-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/20 10:46 AM, Shannon Nelson wrote:
> These patches address an ethtool show regs problem, some locking sightings,
> and issues with RSS hash and filter_id tracking after a managed FW update.
>

My apologies, Dave.  I just found the "Series applied" message in my 
spam folder... Thanks Thunderbird.
sln

