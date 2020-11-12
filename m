Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BE32B12C5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgKLX1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgKLX1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:27:39 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A785CC0613D1;
        Thu, 12 Nov 2020 15:27:39 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c20so5983968pfr.8;
        Thu, 12 Nov 2020 15:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B+kHwzOW9Zwg3hJ04gy0OFk2Xe66Q9iPRpH9oUBGhYw=;
        b=AEALiwRpyYhxMjgEZeXdl+5KhJhjr7zzg5ueiqgGQ8GiZa6tZ7SutIpPVqIts9PQ57
         klV1CT/TH0g8pMMcJOjn35Yj5OnAmJdugxwDMKrcKnvpBQ9xdCpEIO/gbxmH0XmihE4l
         sId4g5fEABnK6EKigbpFriTNvslqcObDrSCtSvF37CZixrPSC6cFJcOtnumFdKtiuAeI
         cZ4unHfbSX+6KKh6HW1fHxE8MFqo0kOsGiCkJqe5qg4CqzZkffZ4O047KjdMHJqyBXgL
         4fp7AiYEVuATDZgpNY4M+uVDjbUd+N8uADMDY1nrL+uyx7H6UdHfMgSrbEGIFs2NLwwB
         Rmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B+kHwzOW9Zwg3hJ04gy0OFk2Xe66Q9iPRpH9oUBGhYw=;
        b=reUOviznCmz7WmD8nzKhgaKheP+IFU6XTPL58cWQRU7d8qYziMTC80HNzlkKNQd9+2
         3IhfhrXj1oaSa13EUsCXIqiBICyPvAstV6UhW+dACNzLd+7Ay1KbGOOYiq4c/vltwPMA
         uQI3F8W6LdVTmJKn7t8k9UCrUK77aNv9G7ZXVdg8y5sGYgmS1wUfY65cqCXiFw6HM40s
         J5xJU1HOyvHMIV6ZlnQ2EeP9/Z7AbXyMqCYQaCcBQm6xKthf/Y7SsbY5/LkUZvNJmGES
         3XO1B2MOSLv+HSZ2UcaGnM+2nt1eQvJuOE5WKcoaCasaFmgH2wrghPCNktMWjGVyneQy
         ucrA==
X-Gm-Message-State: AOAM5308s3pf9ciGEhRu2fAUlm6oPkAP46Z/BzEqm59pIPOQBvA7mmu7
        WjeVNEUjmGNWp/N46hVGlf2+Z5scut8=
X-Google-Smtp-Source: ABdhPJwjl0Ozjs7eYPmrf0XMujYYgVX4dHVcpxtRXK98330zF0CRgQJ/q0FqI7Pnc+7v4a1xtsH+Gw==
X-Received: by 2002:aa7:9341:0:b029:18b:b43:6c7 with SMTP id 1-20020aa793410000b029018b0b4306c7mr1572092pfn.7.1605223659222;
        Thu, 12 Nov 2020 15:27:39 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 85sm7714446pfa.204.2020.11.12.15.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:27:38 -0800 (PST)
Date:   Thu, 12 Nov 2020 15:27:35 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     =?utf-8?B?546L5pOO?= <wangqing@vivo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when
 ptp_clock is ERROR
Message-ID: <20201112232735.GA26605@hoboy.vegasvil.org>
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
 <20201112181954.GD21010@hoboy.vegasvil.org>
 <CAK8P3a1pHpweXP+2mp7bdg2GvU5kk4NASsu4MQCRPtK-VpuXSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1pHpweXP+2mp7bdg2GvU5kk4NASsu4MQCRPtK-VpuXSA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 10:21:21PM +0100, Arnd Bergmann wrote:
> I agree that the 'imply' keyword in Kconfig is what made this a
> lot worse, and it would be best to replace that with normal
> dependencies.

IIRC, this all started with tinification and wanting dynamic posix
clocks to be optional at compile time.

I would like to simplify this whole mess:

- restore dynamic posix clocks to be always included

- make PHC always included when the MAC has that feature (by saying
  "select" in the MAC Kconfig) -- I think this is what davem had
  wanted back in the day ...

I'm not against tinification in principle, but I believe it is a lost
cause.

Thanks,
Richard
