Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99971458F4F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhKVN1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:27:12 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:44704
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236225AbhKVN1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 08:27:11 -0500
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7AF603F1B9
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 13:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637587442;
        bh=R1e0f4ZmYqIeFljQRfPsZaAn1D7W7TwEAn+K9ViDCQ4=;
        h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type;
        b=o54q6cwaq3SCV9uPb4ySDAxLHTvM6pxc8cIXCgBCfnXcFik2dBkeMj1reXieBsFl3
         Fe8LebgFiVOYLtOXrwNnu8J8IP4tDblqAEvVlRAFPVr+5oqmiJZjoaNdXAsjmFICkS
         QPO2E8s+HRRvB6gdnL06Efg6v8NfIOgLQ+8sLeGULyuYrDRJSf7GmlmX4cp2wbIWs9
         dSSSA6owgQudmhq/qq+piDQfRm3KTcm46AWD6Hf1IMuCzKs5cR+9UIXKy/QjltTOyX
         rK3nR9p79060TNVgjTRiBFO+ULvrU/SIqoKYU7w5Z/oNjpcXSFtzAeBrlnDKr2We3D
         INEsJjw7CnY6w==
Received: by mail-lf1-f71.google.com with SMTP id g38-20020a0565123ba600b004036147023bso12247101lfv.10
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 05:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=R1e0f4ZmYqIeFljQRfPsZaAn1D7W7TwEAn+K9ViDCQ4=;
        b=BF/jvzOfPJXFlZSD23GgkOscg5nAOVS9W6FVw3UIYV0Yu4zyZQnbICfL268hHq4bWf
         M7Byq/6m9j7jd249dfo3Aefb+aCb2uzN0PwV/th8wIXXXOvnyv5wA+nqx2LCjbgTjasA
         q7ZTrOv8SETSwP17ULCyMwKB4sx6YBE1WI0In6P248gBzpuioGn9BXzM00IemZP7i2cC
         5P8xbMMc/KpL4otDw0MKgTzQgc2jpo/+1RiFcvlKWAEOMjZkF87sgiWFHiQZWti+PRR5
         RJRTtO6OOJhUWVbJF2MEe2tZOm75PNzTiXv4tK4/GRk3lcKo/V/uT6lRhpGY4phkCVhh
         SOBQ==
X-Gm-Message-State: AOAM530ZKPnvWsxcxuZBnNCXdiSRc0KiKT9+CxmOXmk3oQ9tAK8Blsdt
        0N2dMpv5T5LkA3RLGxIrMq2efPfLepg3aumuOcMngTvuPuS2x+BMdrtUiWmLZ6OGBTPRmunbk3G
        ERV/Kyiifk+OVqKgIg6Usd4g0rLc9qR98YA==
X-Received: by 2002:ac2:4c55:: with SMTP id o21mr54903630lfk.408.1637587441983;
        Mon, 22 Nov 2021 05:24:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZiDvhC66h2OM7vtzyckt8Mrs9a0bz5CbaBmfctj0PlxgiNB/52HyygYddXdzYclcZIZT+tw==
X-Received: by 2002:ac2:4c55:: with SMTP id o21mr54903600lfk.408.1637587441773;
        Mon, 22 Nov 2021 05:24:01 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id w6sm953550ljj.118.2021.11.22.05.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 05:24:01 -0800 (PST)
Message-ID: <c2a668ef-6395-f056-6f39-e909e6b370a7@canonical.com>
Date:   Mon, 22 Nov 2021 14:23:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [neard] neard release v0.18
To:     linux-nfc@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        aur-general@lists.archlinux.org, devel@lists.fedoraproject.org,
        packaging@lists.opensuse.org
Cc:     Mark Greer <mgreer@animalcreek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Cody P Schafer <dev@codyps.com>,
        Dirk Mueller <dmueller@suse.com>, kokakiwi@kokakiwi.net,
        Peter Robinson <pbrobinson@fedoraproject.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

v0.18
=====
This is announce of new release of neard, an user-space counterpart of
Linux kernel NFC stack, v0.18.

I am sending this email to few distro lists and folks involved in
packaging neard (and updating existing packages). Please let me know if
I should skip notifying you or you think I should Cc someone else.

The release includes few fixes.

Source code release:
https://git.kernel.org/pub/scm/network/nfc/neard.git/tag/?h=v0.18
https://git.kernel.org/pub/scm/network/nfc/neard.git/snapshot/neard-0.18.tar.gz


Packaging updates
=================
With previous release v0.17, build requires autoconf-archive. I saw
Fedora and Arch already updated their packaging to include it. No
further changes here. The full list is:
https://github.com/linux-nfc/neard/blob/master/HACKING#L5


Bugs/comments
=============
1. linux-nfc@lists.01.org
2. https://github.com/linux-nfc/neard (as GitHub issues)


Few notes on new names and maintainers
======================================
The neard package was previously maintained Samuel Ortiz and Marcel
Holtmann, which were also main contributors. Last years Mark Greer was
looking after neard. I joined in 2021, both as a maintainer of Linux
kernel NFC stack and the neard.

Under GitHub I set up also Continuous Integration:
https://github.com/linux-nfc/neard/actions

Best regards,
Krzysztof
