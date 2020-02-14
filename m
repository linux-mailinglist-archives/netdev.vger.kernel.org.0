Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED20215FA4D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgBNXWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:02 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37582 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbgBNXWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:22:02 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so5600158pfn.4
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 15:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RD00yQTaWRQhVoIeYbivs0VjY8rWc/0oeTR8kZlaU68=;
        b=mlhAdIpIjDpUiL0kOWdpI5r1tjMYl7/F196K4zfyta+vbun5Xg3O5EkmtLh8TBNsWC
         4oTVN2LH8gFNrPDEqx+13PCt1svShAxekSrlAhH0ayoQ90+bZ/CbD2qy55JaoT4Jwd5y
         gjDJf2nuzRIfg+M1nj0ytwfwgWm7gDLkX16659JOFxmdniYxbgvSSwexubtlxsfX9Whw
         mFJIMYjSGJRf0Q0kcl9lyGOJMbtsdNKrnOCUcnNAAmW7HJTAF9q8l0fvkoqIy0rQC3Cc
         XXP7OsrnzHTBKmVSZhhpMp5X1wDLXQCG5IsZ3AAmxpqEt5fRf4aRukXxigA8npEwvSxf
         TnSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RD00yQTaWRQhVoIeYbivs0VjY8rWc/0oeTR8kZlaU68=;
        b=k/DkbsZzQxa7DJjH/+p9L5hCC6KQ1TgpKzjjZKm0U4BRQEalKUUWAlzHWSqgx8Xs6U
         A6jYBWJa4mzmaDDXu0OD4i0+sD0atWbARmon/NtAN1FTNvRmA77kexemn2kNDLGZTtMH
         fqYFbTZI2GraQlBue5KqcggObKec/V2J8KF7SHKbDOqQbYWA0wxWiCL//9V2296vIkDS
         sRXko8CVaB8cUUZGPIbyvG9Mtt7qevt3i5eFhSJ8ZEVbC/i9z1pgKyEcEZJFGmMsNGOV
         pkkr3/b0M+Zpe9icVEaBbmXV5VNiciXcE0gqT/Ufw78Redk/42Ks6vpmC/37M2bbKE8b
         lvvA==
X-Gm-Message-State: APjAAAW6rqIKlFgck1KHmBE3Efb+mFfPVfYEdgmAJO4FY/ei9cxNbgz4
        UMcj/ENmH9w4SHBzZhhzTgs=
X-Google-Smtp-Source: APXvYqySnv0TxH3+yKN7nHCE5fg3MmGRak1Mbt32Otcnnq3m0H06JohkjJrOzFzt1iSsVcyfWn2jdQ==
X-Received: by 2002:a65:5c44:: with SMTP id v4mr6216168pgr.340.1581722521487;
        Fri, 14 Feb 2020 15:22:01 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id q8sm8289268pfs.161.2020.02.14.15.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 15:22:00 -0800 (PST)
Subject: Re: [PATCH v3 net 4/4] wireguard: socket: remove extra call to
 synchronize_net
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
References: <20200214225723.63646-1-Jason@zx2c4.com>
 <20200214225723.63646-5-Jason@zx2c4.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d29e7d7e-5e60-9790-4851-eaf7bc14a58c@gmail.com>
Date:   Fri, 14 Feb 2020 15:21:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214225723.63646-5-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 2:57 PM, Jason A. Donenfeld wrote:
> synchronize_net() is a wrapper around synchronize_rcu(), so there's no
> point in having synchronize_net and synchronize_rcu back to back,
> despite the documentation comment suggesting maybe it's somewhat useful,
> "Wait for packets currently being received to be done." This commit
> removes the extra call.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

