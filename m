Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25001E5119
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgE0WWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0WWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 18:22:00 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E60AC05BD1E;
        Wed, 27 May 2020 15:21:59 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g18so3764000qtu.13;
        Wed, 27 May 2020 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O0EZFokD4VETW8hilHGvqiWo+AY18MjoTOCmb0j2QP0=;
        b=s2T8fMW9uZpIMjWGcD1ZLd6JVhc9lKb0qUFORy1p1/+usP51vVfE7imxKLhJ4zBXJL
         X0mKKqb2aJCwjf5JmHRE1iXQ5HDbob9tUqqLNARkQ4SclF98OdsiSN0H9L7Jk7a0uncw
         hkkYgpvz1WcPKKAIE5+ZaRlyLjX6J5dcqyx6Jy/iaBSWUW4u7GmrcX5FGeEQ7HFP7/to
         Y3/evqAvP8745WekeffD2AUo5xLwINjsmVd9GSXBQoU8+b3mUNz7Y2lZUf15r70X16G7
         pzzvqB9L/QSRoPPhm2dplOLBsn3NmgGCi0h/ITu1v08iISeTVI8BH0uIZYxV4HlMnPo9
         yrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O0EZFokD4VETW8hilHGvqiWo+AY18MjoTOCmb0j2QP0=;
        b=I0rhIIffJ1k5UhhrCmd00Q8uu+0FFACijdUQHhoFcJW8PXbxq+eYTBNVL7ACu2TKXd
         DBa67UNzvureLWPODO/tVk/bREAezYpQTi1RR1TBKf3dH9+ucmKzqsi7Pfsc7kXHOsJv
         8fDAWt7vDBMFHspQh68O5l1XBpS9vKqK0khpffX6Qi6/6HkbsYMXrGdGxVuj18Smrcib
         uKerlLz94jQDwHrTJdxb/x9uU06HGhO4DplzLGJwqQxXDdsdU7Ibp3Nz0n9YUneCtGzF
         KvpOG3KdtbcrVwZsRnwxSzp5LLCTpaRU6BJgJB1aHNaXZFkSkN9xoWCDg8Q829D/OgEQ
         YYKg==
X-Gm-Message-State: AOAM533pYVEpGrCqnJnCBJMyUL0o16x4B7Zca0faEFl74wTuASQvH+Jw
        40QO0CqIYyYVmcPqlEWvuL0=
X-Google-Smtp-Source: ABdhPJyOgdLDKEz0HQkCQmvOCQBIMuQEJnT24eYzL6cb96knhDKVZ2UOmt/SMnmijP1sKg5MpJ9iCQ==
X-Received: by 2002:ac8:6cf:: with SMTP id j15mr107653qth.143.1590618118847;
        Wed, 27 May 2020 15:21:58 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id v14sm3909630qtj.31.2020.05.27.15.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 15:21:58 -0700 (PDT)
Subject: Re: [PATCH v3 0/7] Statsfs: a new ram-based file system for Linux
 kernel statistics
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
References: <20200526110318.69006-1-eesposit@redhat.com>
 <20200526153128.448bfb43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <6a754b40-b148-867d-071d-8f31c5c0d172@redhat.com>
 <20200527132321.54bcdf04@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <af2ba926-73bc-26c3-7ce7-bd45f657fd85@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6fa4439-c6b8-63a4-84fd-fbac3d4f10fd@gmail.com>
Date:   Wed, 27 May 2020 16:21:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <af2ba926-73bc-26c3-7ce7-bd45f657fd85@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 3:07 PM, Paolo Bonzini wrote:
> I see what you meant now.  statsfs can also be used to enumerate objects
> if one is so inclined (with the prototype in patch 7, for example, each
> network interface becomes a directory).

there are many use cases that have 100's to 1000's have network devices.
Having a sysfs entry per device already bloats memory usage for these
use cases; another filesystem with an entry per device makes that worse.
Really the wrong direction for large scale systems.
