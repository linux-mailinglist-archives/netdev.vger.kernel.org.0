Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B371CA300
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgEHFyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgEHFyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:54:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F8DC05BD43;
        Thu,  7 May 2020 22:54:36 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 188so8939745wmc.2;
        Thu, 07 May 2020 22:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cBuXlY0lPbTzvqFi3J9oIqLP+OF/m7YpRIj6GR1Gj+U=;
        b=K1VwBxCBXCfE4HZYWiqihZRJtx8ctP1mVKfq1o6aCJtu/K2DwQN6yjel0+96+k0mcG
         0uuiGrKz4zsQBMXrSSEoq364xNTJ0XfUyV8v85i/bpTYtVg9HOLeugf599IF0IqQbtQ0
         HFuvcYQomO1LBbkbc814Hmv+6PqZ8vuzbej4nEQDUqXoysFOc58ddm3QesuV+2jOOEki
         fJy7J3YgVTkYXJsIaZHg+NAtJmVDKvdUCxK1SIi+tER4fIclIQXInU9RVQAgG+SaECXp
         2NEaDBLaPWFmApTkZQjPaOAgRMoh6nbkR85XVuxIcheeDeBQLR48s6gZdmQ+i1xfKWoY
         EByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cBuXlY0lPbTzvqFi3J9oIqLP+OF/m7YpRIj6GR1Gj+U=;
        b=iKtH28/jAlYFNEUvovXt+m0ZK3pq0rUxU1dqgAb33jmxdFZ+n5HG/TAEW/2BWTjVF9
         wxPyOphoSWlbSDbk7frDYrOP6jKcORBWFCTJUcdud/9NHxDxqPeUn0xFRkmSZQ2Msm4F
         yv+hUzWQK8rWPjOZfGxLKck4EqtqNXKiQePjt/10Niz4cp9ePSmHq8Xmi85kHtoITS9m
         G7OV4c9jwLtCEQgGNWBq9S5e5EWtXjYN3e9N1sxiGneKC0g7ypqjv89nSgRvkrALfCsh
         n4XHzJiesSTiUSQlG+urstJZ75L9oOUcJRRG1ywDNQArGJIXQdKLSvxTiFCbPEtB0tmE
         pEDg==
X-Gm-Message-State: AGi0PuZX7SZTEICcrDLu24QEBZ49nBsEqM4hz5kd1s03tgvqhy1Z/2A5
        1Qyxrs28g9JIRa/KpH8q1sw=
X-Google-Smtp-Source: APiQypJN3BPfHFPyK3WDkQRQQXzBNgHR1dVgfWeEuUZhd4lAzK8YcVD4LeyB6dzQUvulSYABR4hCgg==
X-Received: by 2002:a1c:5f46:: with SMTP id t67mr15219360wmb.156.1588917274753;
        Thu, 07 May 2020 22:54:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:e838:acb:794:1ab9? (p200300EA8F285200E8380ACB07941AB9.dip0.t-ipconnect.de. [2003:ea:8f28:5200:e838:acb:794:1ab9])
        by smtp.googlemail.com with ESMTPSA id o6sm1177075wrw.63.2020.05.07.22.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 22:54:34 -0700 (PDT)
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
To:     Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org
References: <20200505140231.16600-1-brgl@bgdev.pl>
 <20200505140231.16600-6-brgl@bgdev.pl>
 <20200505103105.1c8b0ce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMRc=Mf0ipaeLKhHCZaq2YeZKzi=QBAse7bEz2hHxXN5OL=ptg@mail.gmail.com>
 <20200506101236.25a13609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMpxmJWckQdKvUGFDAJ1WMtD9WoGWmGe3kyKYhcfRT2nOB93xw@mail.gmail.com>
 <20200507095315.1154a1a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMpxmJUEk3itZs4HujJOXUiL80kmEvGBvLF0NFc2UQoVDVTWRg@mail.gmail.com>
 <20200507155650.0c19229e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c6e12eb6-d6ea-9ba9-4559-b2eda326601f@gmail.com>
Date:   Fri, 8 May 2020 07:54:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200507155650.0c19229e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.05.2020 00:56, Jakub Kicinski wrote:
> On Thu, 7 May 2020 19:03:44 +0200 Bartosz Golaszewski wrote:
>>> To implement Edwin's suggestion? Makes sense, but I'm no expert, let's
>>> also CC Heiner since he was asking about it last time.  
>>
>> Yes, because taking the last bit of priv_flags from net_device seems
>> to be more controversial but if net maintainers are fine with that I
>> can simply go with the current approach.
> 
> From my perspective what Edwin suggests makes sense. Apart from
> little use for the bit after probe, it also seems cleaner for devres 
> to be able to recognize managed objects based on its own state.
> 
What I was saying is that we should catch the case that a driver
author uses a device-managed register() w/o doing the same for the
alloc(). A core function should not assume that driver authors do
sane things only.
I don't have a strong preference how it should be done.
Considering what is being discussed, have a look at get_pci_dr() and
find_pci_dr(), they deal with managing which parts of the PCI
subsystem are device-managed.
