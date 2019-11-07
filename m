Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8383F3533
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfKGQ61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:58:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34469 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKGQ61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:58:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id e6so3915314wrw.1
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=duuZ/GEcOj1lMi9UGA5Gk5HIPaCv9sbL2SkkSg2xRiM=;
        b=bLyicoN/oBrGbatrICWZKI+duF29G+47XWdRzsIZkvTBjpJbLNXhVsVkC79qxqeCyE
         GrXOueZY5k14qC8nADucD9PnD6j9rjkpap4ENKK5mkxMOGCkU5fJcS9K5xoYHoSYo6oh
         siCDUh2VqshjlFkmMLKJd8qU5s65a2frvoj8no02l3MMbCxuh31z5bELZHAcPAAYQRmT
         Q5GnmBH+pcf+PJs+JnOUAQWiS1jbIx8+5/DFFReyQcKPOVv+S49HXnaVOaxO+d5Ggo7x
         WmN9owozs43xvh1kLmabjEnn4iQ/RbjrscAdxdrtbXvwIwo6USfrvrp2nvZ8RWp0EIDY
         kwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=duuZ/GEcOj1lMi9UGA5Gk5HIPaCv9sbL2SkkSg2xRiM=;
        b=r0KJhPrkXdIllVzCSiiiV7+dUCu30yXf16+4l7jdPBrQG7DrEaRJa1P9u7C5UIhhG0
         yAuMcBQUqbRF4gZozxGzXqO9dUUK9a1fhGOeBEKOy/jPTQUe4xH6J8FkvdkTI4biDPG2
         bMU1Bt6V6xbsCPRNTngLc1lFARgpWRtLqsF//YQfpo+yMSumWGOSPqCvAzwLhrEYwRmC
         6nbkzFPip4ie7Cex1McNeoTnKtmZjQ+musH9RmJ6xlmYjfS9yuo2cz6ZdP6N19PLqmgp
         4DjoiYhJAx1BkLu0c/wmoW1V2kd3KM7oF5SvSrl8R2bkIX0O1XmmkCS24Y8Mt+/7zT9K
         aedg==
X-Gm-Message-State: APjAAAXnOS7dGVlrzwChWETqIE4LjkdqtOcUsvfaF/C4ucQiV+Mc8wyJ
        9koyjJDEphgc9xcHV3QJjKv5t8YfDIA=
X-Google-Smtp-Source: APXvYqxUPQt/UQq91K5FWXcV7jPBqeDBMXe8DhnwkRTqSBFfcNvvxM6M3M3acec0a/Aj7sCn1c0WrA==
X-Received: by 2002:adf:e602:: with SMTP id p2mr4043485wrm.348.1573145903787;
        Thu, 07 Nov 2019 08:58:23 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b63:dc30:95e0:8058:2b4b:3437? ([2a01:e35:8b63:dc30:95e0:8058:2b4b:3437])
        by smtp.gmail.com with ESMTPSA id q5sm2251463wmc.27.2019.11.07.08.58.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 08:58:23 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3 1/1] net: ipv6: allow setting address on interface
 outside current namespace
To:     Jonas Bonn <jonas@norrbonn.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191107132755.8517-7-jonas@norrbonn.se>
 <20191107135652.19629-1-jonas@norrbonn.se>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <fb330ba7-1b9a-3fbb-4351-813b0928dc1b@6wind.com>
Date:   Thu, 7 Nov 2019 17:58:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107135652.19629-1-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 07/11/2019 à 14:56, Jonas Bonn a écrit :
> This patch allows an interface outside of the current namespace to be
> selected when setting a new IPv6 address for a device.  This uses the
> IFA_TARGET_NETNSID attribute to select the namespace in which to search
> for the interface to act upon.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
> 
> I messed up this patch and the cleanup code path wasn't included.  It
> should look like this.  Sorry for the noise.
You cannot resend just one patch, you have to resend the whole series.
