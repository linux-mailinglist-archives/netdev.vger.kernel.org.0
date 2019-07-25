Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241D17436A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 04:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389329AbfGYCq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 22:46:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34131 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388165AbfGYCq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 22:46:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so22793904plt.1;
        Wed, 24 Jul 2019 19:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aGeqbbaRQz52Mrxm18aXtkYJrSyeGJbcuPy0BL4Y1Vs=;
        b=uEwcJavHy2kklEv19UdZJTg8zda6WO/bZLW9FDuWCcIXLJCQz1IYlkWkQFwiJXgaSr
         z2Ew6K9ayMT6PYMIW8SaX0ASAjZHghbYNkPsc6zYcJylNVC2cFJYVyBxrvThd0xAp6gd
         mOXZOpzhvGy+u0bar9h7GDanOG1NQXF6DrpbIrkKY6p9GfWTJKMzpNU30MODTgRYgVYj
         6NnFwXJO0yrRfCuMqna6kieSCzG9sXYdgxPiZ6GPbUHeUmPnferi5Q+e9sarf2n7ayNS
         8GHQXgSuGsTBk3nqdL42iyCJ6gsiSFaFa2E0C0L9Aqpz8JgrHjN2MEXEzATMO2fRfbe6
         Ylrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aGeqbbaRQz52Mrxm18aXtkYJrSyeGJbcuPy0BL4Y1Vs=;
        b=kOoXG/DcrsWf77KLDYy3iP6e+4PFO7JtDFXKUoqrDYekE5fAM4ot2z9BoTuzyz4yXR
         fTOFt0OMsl9E18UeTg6zWg2SK8ouWetrR+h7rdPG0Aa7Dja/hovaixMJx18oxxkofM8K
         T+0ASSMIjJ8HBIMWvTohDpYLsHdKoR4EdfGY1c7Qc+rEIlaX/4xT+t/lFis+pZBT57v2
         g3SsOd4/6PH/mfGpFehLPQYMW3Ost1aiub1lAYpv8M7nFhIzffP9sC4y4eAZ0vNQwdxu
         5754nv311sTQ+MEY8DKyk5s2h03hzt9CJE7VK9TJxKl1HkHi1y+dJTgWVuEi3dEdR8sa
         UEAA==
X-Gm-Message-State: APjAAAWPjg0qeeYhhPm1NbFqpc+7UlrlvzDlUnibotSkRIQlKVhH77NT
        tVddQ5R0vPvy7rAJ96A3ZU7MzsOkAEA=
X-Google-Smtp-Source: APXvYqzn0eD2QRa02YoHPNpKVxuwggwW9Gwuz5NywLmQ8LRrbVXQiqMsn20cTsA7I4jVD5JgOr/2Sw==
X-Received: by 2002:a17:902:8490:: with SMTP id c16mr90566604plo.1.1564022786580;
        Wed, 24 Jul 2019 19:46:26 -0700 (PDT)
Received: from [172.27.227.155] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 14sm46295162pfy.40.2019.07.24.19.46.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 19:46:25 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED
 flag
To:     Thomas Haller <thaller@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
References: <cover.1556806084.git.mkubecek@suse.cz>
 <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
 <0fc58a4883f6656208b9250876e53d723919e342.camel@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e4ba571-de11-8448-c44c-cbc7024ab9a4@gmail.com>
Date:   Wed, 24 Jul 2019 19:46:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <0fc58a4883f6656208b9250876e53d723919e342.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 1:57 AM, Thomas Haller wrote:
> Does this flag and strict validation really provide any value? Commonly a netlink message
> is a plain TLV blob, and the meaning depends entirely on the policy.

Strict checking enables kernel side filtering and other features that
require passing attributes as part of the dump request - like address
dumps in a specific namespace.
