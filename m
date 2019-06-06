Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5149437ABE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbfFFRQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:16:40 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38781 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfFFRQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:16:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so1944274qkk.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 10:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RoNHRbh35P7hELgeV2EKZhdMQ3VSv4uD+raXS1vIl2s=;
        b=AKtduvkmIopBUZT6B52y0WLnj5SrZX1JVye9xW5+nxEe+q2rZMf/O9bI6lciLU6Gr/
         9PW3W7RTgMXm9r7t0L3PUzQHrVT6gaP08sUx/cyJF9btP4v6hdfPENrTLUg5JC4uMEbe
         RhGQ5OpdjpfaolyFOLmyMcdO0WAd7h8JGBDZlk79nhC69vNLpjkykR8wCYR/c0LONuTx
         W9qT2JMaohcHW3T0m6U2AYrnFXvabAniozud1OuTzbvOxq2e4LRS8yfq7WyynaZ8eun/
         wlHPevYzEVswLKq1Qmitonxr/hXcTw81/FA483myn9i27wQ9Vk0fGO4TPBOnVcDj5Ifb
         zi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RoNHRbh35P7hELgeV2EKZhdMQ3VSv4uD+raXS1vIl2s=;
        b=o0utguvVYJET2Tvmt5QIv/8DUOmwUmi4QKpMtmw9sETK7dsdAkAqX6noPpB24Nx1JE
         4JbdEbKUMlIhG2kG8w256gOLjXq+EdE5UKCOi5/LF05VoW1s2YbgqtbrLtgozYhMqzJX
         IuCqUWk8+XKxYMea1+4YIKXv36gd1Ppp2hceDMXzT8Ukb3koCn5tYuqXLs2dtul82b6E
         wxwJXYkVPQEsnBJ3SIlcHcOiuqyWQby1E7cJNpjqrclVotg1g4BUD1DS6fj6eVMHNmyt
         Q9dO+Bu8IK2Wc0YT85OkVWOsN9gHEqnR1elWUEMw6TQhwj0FEpA3Ff9fOvmYPUb7Te/z
         hXkw==
X-Gm-Message-State: APjAAAW5fkPS4FN8sJUmZO5sHQbor+Znd3R44JHGuXb7kMXw5xuXWLZ2
        EH7E/rVdSA9cmS87tlmT/UFvRg==
X-Google-Smtp-Source: APXvYqxxA+or+AtfzFAcOpbF4Nf7CnEnd42coiq1DXPiT0mivTCgGcOD7CNRAI2MEhPHG+2nHhQbWg==
X-Received: by 2002:ae9:ed0a:: with SMTP id c10mr38863532qkg.207.1559841399553;
        Thu, 06 Jun 2019 10:16:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s125sm1088029qkc.43.2019.06.06.10.16.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 10:16:39 -0700 (PDT)
Date:   Thu, 6 Jun 2019 10:16:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        "Bshara, Nafea" <nafea@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190606100945.49ceb657@cakuba.netronome.com>
In-Reply-To: <7f697af8f31f4bc7ba30ef643e7b3921@EX13D11EUB003.ant.amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
        <20190603143205.1d95818e@cakuba.netronome.com>
        <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
        <20190603160351.085daa91@cakuba.netronome.com>
        <20190604015043.GG17267@lunn.ch>
        <D26B5448-1E74-44E8-83DA-FC93E5520325@amazon.com>
        <af79f238465ebe069bc41924a2ae2efbcdbd6e38.camel@infradead.org>
        <20190604102406.1f426339@cakuba.netronome.com>
        <7f697af8f31f4bc7ba30ef643e7b3921@EX13D11EUB003.ant.amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Samih!

Please don't top post on Linux kernel mailing lists.

On Thu, 6 Jun 2019 10:23:40 +0000, Jubran, Samih wrote:
> As of today there are no flags exposed by ENA NIC device, however, we
> are planning to use them in the near future. We want to provide
> customers with extra methods to identify (and differentiate) multiple
> network interfaces that can be attached to a single VM. Currently,
> customers can identify a specific network interface (ENI) only by MAC
> address, and later look up this MAC among other multiple ENIs that
> they have. In some cases it might not be convenient. Using these
> flags will let us inform the customer about ENI`s specific
> properties.

Oh no :(  You're using private _feature_ flags as labels or tags.

> It's not finalized, but tentatively it can look like this: 
> primary-eni: on /* Differentiate between primary and secondary ENIs */

Did you consider using phys_port_name for this use case?

If the intent is to have those interfaces bonded, even better would
be to extend the net_failover module or work on user space ABI for VM
failover.  That might be a bigger effort, though.

> has-associated-efa: on /* Will specify ENA device has another associated EFA device */

IDK how your ENA/EFA thing works, but sounds like something that should
be solved in the device model.
