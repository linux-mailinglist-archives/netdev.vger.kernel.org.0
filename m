Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74B7D83C9
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbfJOWfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:35:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42532 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732040AbfJOWfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571178923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9F2rYjWK9ziFocCIMNfTpax2GOtKztQS4lutNS8gIlc=;
        b=I08UD3XL8lIM22nH8nEOZ0wgJmDAfbwiJEuZsZ+l1Guz/8KMoWPD3QqTzOxilutv4CdC7r
        MTsMP1gs50Vkqzlvxa6yj62UWcmV84MU6zMpp+Z9YAjNGdaX8mHkmlW5VMsqmxlzv5OLio
        t2whgwpkJgQ4zxp6DqNTmPPtMgYq+uI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-p2gzu8f-PXOP3sgrQhqMMQ-1; Tue, 15 Oct 2019 18:35:22 -0400
Received: by mail-wr1-f72.google.com with SMTP id w2so10881222wrn.4
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Klw9BBs/uRXS08lOiDz40aM4kc+jmIjD/L7OQgU9RpQ=;
        b=S8o6gLfRK9k6TLg5iONzWULmNJimftUu7Ml5jV+6sbSYBG2JGDGF07QNfPLYmJW7YG
         HCTuL325teMqLXJTI2YrVygRjCgD+yLbxx1LB/JbibFFEfhe4LdjUCukFgr0L4Ju6DZg
         fGB0vH0c9swKlwlgJwv6c3/q2s8oa/RiTaVaJBP0OybzmO+PhPQpJK7FB9QJfIPaLGQY
         LXYZdRVwU4nskr1oA0Q8agkCGSDEveYnALEuJizyFI12voaNHth21ojbBdatbU2c3o5B
         3bJjkrRdIUr1Y/qdZtFuWoRzONYrh2OTDL72xDCm1DrVxkE9zAf1kIz2XiR6BSOwZSdG
         TkdQ==
X-Gm-Message-State: APjAAAXTEdt34BrXequYpDL75yTxOnRHxZiYAvFRSPiWeAb98zC+eGvk
        WpBnXSrTQaeFDDuyLnkvd9u8EANN9fbiU4IvlyabVlHOApnErl3JwSRPxZ/BeJwWjC0NbjZsjft
        K3oYQKgWPmB27Drcw
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr548002wmc.11.1571178920975;
        Tue, 15 Oct 2019 15:35:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy1iyLLTiDLs+t2SLsnm7KLC4V/LNTF3V6ZsBtx2m2Wming/W18J0rGV7YsyfVCmmOqtU/SdA==
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr547985wmc.11.1571178920686;
        Tue, 15 Oct 2019 15:35:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id y13sm33305655wrg.8.2019.10.15.15.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 15:35:20 -0700 (PDT)
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, nd@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
 <alpine.DEB.2.21.1910152047490.2518@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cfa31e7c-83c4-0e16-ff7d-c6d6f0160e98@redhat.com>
Date:   Wed, 16 Oct 2019 00:35:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910152047490.2518@nanos.tec.linutronix.de>
Content-Language: en-US
X-MC-Unique: p2gzu8f-PXOP3sgrQhqMMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/10/19 22:12, Thomas Gleixner wrote:
> @@ -91,6 +96,7 @@ struct clocksource {
>  =09const char *name;
>  =09struct list_head list;
>  =09int rating;
> +=09enum clocksource_ids id;

Why add a global id?  ARM can add it to archdata similar to how x86 has
vclock_mode.  But I still think the right thing to do is to include the
full system_counterval_t in the result of ktime_get_snapshot.  (More in
a second, feel free to reply to the other email only).

Paolo

