Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6822F01B3
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389930AbfKEPlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:41:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37777 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389507AbfKEPlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 10:41:17 -0500
Received: by mail-wr1-f68.google.com with SMTP id t1so16008501wrv.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 07:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ozAKIPnjiYc9fpO5f1nk/BdjyvPtZaOVmyYPtZzq5c=;
        b=KKuqECKtOsEoiZzDv0lUZSgk74+1eyjHrFgAQfyyzI1wNA34tP+9M4eeNHLzNrZjyM
         ruLOtV/QCxUnvUY5T1Cna+crOAcgQJoyE5kax33oAMdCkhhBsfYvpdbTbakCZFdAeQQl
         +vpw+X6aenWO/a3rKJPft4c/XV9fACSYzx01EGdcqrOhzpW8LVfGJFB9Xkc72/IhwRcD
         iDJN8vNTbWfGbpZZbnlacGQLNGTJ9Sh7T6OHCxAR6ZRakZTox3EF5Eb/yj1y3p/7q7fB
         qDMkRv+sGSg7/dbvTzBZQl0UQttZFX6aUdnZtZJIBC5hhy5KyKlWYOLZJVW4tlnJJOpN
         +EVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3ozAKIPnjiYc9fpO5f1nk/BdjyvPtZaOVmyYPtZzq5c=;
        b=nUxrxzWFAAwQPWXK0uuOaZOwF1AMiKYKrPwbKC2u4GDa5/Q9ijF0O8n9NkqzR71q7E
         FNnMtQB1xldK6Aof17Z1ij707pmjqTnWWegiU450KKccXwA5/99OKlcqK46njQJmHmLq
         /iMW1vhFvzOZbJJEwSO6lcrBuaIYlcd5OVMEEa7MNN4+96GtFzI5LWkCw6INyq2BOgM1
         YUdk3DshnRGjUAMPsBoba6vwjWP2Aygt0sApvOIPnlKfx0fadYnJQij4Qajs2NayzbxH
         ytqkCiNyG8PAK2k3UHh0BC7T/MlOJvIBhczIFgA7fLhQI3XKWyd4/6zjqCW3G8tFbqyS
         oD8w==
X-Gm-Message-State: APjAAAWh0BuEjnrzppaTVAg2PSQQbIUv4lahd2t4G5ZRG4uDpd2cM/3Z
        xK8cX7euI0UXVi4JwuvEC6Ldrg==
X-Google-Smtp-Source: APXvYqzpY54XPKPv0DpY4HfQOyFhFG+kQvDUvviA9Wor2nmD4Qla22g3Fv4tKgk/jU/oUiOGfjxXow==
X-Received: by 2002:a5d:6b04:: with SMTP id v4mr12056106wrw.219.1572968475516;
        Tue, 05 Nov 2019 07:41:15 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b63:dc30:f096:9925:304a:fd2a? ([2a01:e35:8b63:dc30:f096:9925:304a:fd2a])
        by smtp.gmail.com with ESMTPSA id a6sm13961098wmj.1.2019.11.05.07.41.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 07:41:14 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 1/5] rtnetlink: allow RTM_SETLINK to reference other
 namespaces
To:     Jonas Bonn <jonas@norrbonn.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191105081112.16656-1-jonas@norrbonn.se>
 <20191105081112.16656-2-jonas@norrbonn.se>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <4c57e4b2-13d2-63e0-c513-62cd786497eb@6wind.com>
Date:   Tue, 5 Nov 2019 16:41:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105081112.16656-2-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/11/2019 à 09:11, Jonas Bonn a écrit :
> Netlink currently has partial support for acting on interfaces outside
> the current namespace.  This patch extends RTM_SETLINK with this
> functionality.
> 
> The current implementation has an unfortunate semantic ambiguity in the
> IFLA_TARGET_NETNSID attribute.  For setting the interface namespace, one
> may pass the IFLA_TARGET_NETNSID attribute with the namespace to move the
> interface to.  This conflicts with the meaning of this attribute for all
> other methods where IFLA_TARGET_NETNSID identifies the namespace in
> which to search for the interface to act upon:  the pair (namespace,
> ifindex) is generally given by (IFLA_TARGET_NETNSID, ifi->ifi_index).
> 
> In order to change the namespace of an interface outside the current
> namespace, we would need to specify both an IFLA_TARGET_NETNSID
> attribute and a namespace to move to using IFLA_NET_NS_[PID|FD].  This is
> currently now allowed as only one of these three flags may be specified.
> 
> This patch loosens the restrictions a bit but tries to maintain
> compatibility with the previous behaviour:
> i)  IFLA_TARGET_NETNSID may be passed together with one of
> IFLA_NET_NS_[PID|FD]
> ii)  IFLA_TARGET_NETNSID is primarily defined to be the namespace in
> which to find the interface to act upon
> iii)  In order to maintain backwards compatibility, if the device is not
> found in the specified namespace, we also look for it in the current
> namespace
> iv)  If only IFLA_TARGET_NETNSID is given, the device is still moved to
> that namespace, as before; and, as before, IFLA_NET_NS_[PID|FD] take
> precedence as namespace selectors
> 
> Ideally, IFLA_TARGET_NETNSID would only ever have been used to select the
> namespace of the device to act upon.  A separate flag, IFLA_NET_NS_ID
> would have been made available for changing namespaces
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
