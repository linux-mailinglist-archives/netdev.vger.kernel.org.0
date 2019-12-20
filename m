Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F770128240
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLTSa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:30:26 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37434 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTSa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:30:26 -0500
Received: by mail-qk1-f193.google.com with SMTP id 21so8431377qky.4
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 10:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jEIabRcDG+gBZu1uBxXqMBLXMqwcvYlDm+SzbmLASeY=;
        b=rlbCNqCdFubEdmJteyCs/XVSrrE5HsOLSohG7UdJGjwns9hpQ8R+k099xnqbvYmUHc
         D0xn0wYT3cn8YSU6plzziy9luRIZO9jIBy3GE86OfrAvaubS2TChgYoRWvll6IIl6ZUD
         61XZXef36rXcG2R/QDlKEpFIm29deiPOOlCM/yKGmzHJRijoWzPmI5IqQ7ZqR5ldnIzc
         rSGAGwa7L2OhhXc2NMXOfrKc0c826XA65mAeWKS4VXZ8mWGGwzkZeS/Xat6RtecqVKXL
         GuQRFMBROumFDaj/nox/mAzs6qRjK2qnwauo+6lV0Z0931YVPDEtd7lOGGncc/C1OjYh
         9BTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jEIabRcDG+gBZu1uBxXqMBLXMqwcvYlDm+SzbmLASeY=;
        b=fTGFThC1vESplruWJpqAofDdTKkBUW86Z0bkZ3JDROQ5IbbARfJR2Bz1oMrGP3n8TL
         TWMe395NIgsNfszJY075EYoTo8AO/XB3anOcRiztIgTRxt6uiicr8HD9U9HrTQ4M75iH
         flLhZdCZ7Py73MRVb9EhKyBb30y0EYo9rMB6+OXsNSKgAJMxwMSOUh+NSvaz8fMOhT0M
         z0hfxRqsBXfXMJAZNq7BabrhINxG25B+4Ue6EmueM39uGFRMYDe49Djo1ZvkAi48WvSg
         FhgtNtBlhVdv1j4ev/wjo/TQvqANqaP9WLlnLHHiV5TIDu2IKB3adE+reRbItzylstbW
         KjBQ==
X-Gm-Message-State: APjAAAW7ZyAtoq3i3ArvamV/ZAbqT2NZcdXVXa2IZbrUWZy4lXHXYZNt
        1ONIEJP5z2Yk3zZW27vNvmQ=
X-Google-Smtp-Source: APXvYqzXnNMghEhEtOzHzjYbrlBV2WbWlKCxs9ExtqDn4XPQk/C3fRO6x7ER7w294nRhlsUPbLVb/g==
X-Received: by 2002:a37:a98e:: with SMTP id s136mr14653095qke.253.1576866625711;
        Fri, 20 Dec 2019 10:30:25 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:d462:ea64:486f:4002? ([2601:282:800:fd80:d462:ea64:486f:4002])
        by smtp.googlemail.com with ESMTPSA id n7sm3066906qke.121.2019.12.20.10.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 10:30:24 -0800 (PST)
Subject: Re: [patch net-next 0/4] net: allow per-net notifier to follow netdev
 into namespace
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
References: <20191220123542.26315-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <72587b16-d459-aa6e-b813-cf14b4118b0c@gmail.com>
Date:   Fri, 20 Dec 2019 11:30:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191220123542.26315-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/19 5:35 AM, Jiri Pirko wrote:
> However if netdev can change namespace, per-net notifier cannot be used.
> Introduce dev_net variant that is basically per-net notifier with an
> extension that re-registers the per-net notifier upon netdev namespace
> change. Basically the per-net notifier follows the netdev into
> namespace.

This is getting convoluted.

If the driver wants notifications in a new namespace, then it should
register for notifiers in the new namespace. The info for
NETDEV_UNREGISTER event could indicate the device is getting moved to a
new namespace and the driver register for notifications in the new
namespace. If the drivers are trying to be efficient wrt to
notifications then it will need to unregister when all netdevices leave
a namespace which it means it has work to do on namespace changes.
