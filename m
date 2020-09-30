Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA4627DD50
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgI3ARv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgI3ARv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 20:17:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906B1C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 17:17:49 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so84351pjd.3
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 17:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=UIi+bwCfKptWkrpTCoEt1MhGjxbv+ylTfLMKZ+vLAQQ=;
        b=x5+mw6pHk8vvMuKjoKXwAzXr8W3hHU62C7nTALkH7O0QNJ8lydkEnlG3nc6XTzLHTE
         WsOplMGINoBYtpOx14zwOgXkp1wHBPsNkGsS7zEr/aMYklPVB/8MNmUJk7dTetZ93gaN
         IbsfKiSqXwMxeaBoHIIho1SOxUN+BmFaPJKTB6Tk7q8vYX5hPEVmGAor0oL+z1Dn+1pY
         bwSL6fYbbCbQ7/jhAH2GZhldjyMH32n2nR5VpGOZt4WFqnPers5OLgByfOY9yy022VL1
         23OtShHr3x7NN2YsvV1OjFHugncUfLzusgzZGnjctQEMy0hjbfGet3LLJX/B6+aeZOi9
         7fqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UIi+bwCfKptWkrpTCoEt1MhGjxbv+ylTfLMKZ+vLAQQ=;
        b=ZBplxwXOzHrD009cESw0udleQ+MAvAGjlAxYpjDTjBliXxhtMSc2cMtfaNfdyVvjoD
         91xkw3MUVpiVhNpBDPPbkm6oWaRlVvBPmtsNVocCCFi0JGSnv5ThVloPDINNbGspLLHc
         NEGB8Ktm+IbxtjDwr4FrrqbhDeCzYfFTejN/lbEcgwk7/lDzgmc/BKvW5m4wK0hm8v8g
         2RBOlGWQW14BStnAwAb++5dmn6rQcXYE3rPZSBCcS1Zic5V9HmFZIEc8rMGYTlne+bgu
         8Gdyd8++eHPvf0smilEL9jdUbOoZW11c8YX2IE3kTg41T5p+Pe93EuhyP+10yEgkw7iP
         SjeQ==
X-Gm-Message-State: AOAM530N/DYpyAM1wDFhdmrZUKuZ/ojnqnQo/GAwicOasX8V99MXpNS6
        c5YSFzXIRXygSfdBaBiwdmO8oQ==
X-Google-Smtp-Source: ABdhPJxrL0rConQiw1R6J55XwDCcMasKrZ2d4Ql6qHf+9DFsuDHPhQPnZXWIqGzCbI6OuSePqxVjIg==
X-Received: by 2002:a17:90a:8e82:: with SMTP id f2mr95533pjo.142.1601425068871;
        Tue, 29 Sep 2020 17:17:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c9sm6029098pgl.92.2020.09.29.17.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 17:17:47 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] ionic: prevent early watchdog check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200929221956.3521-1-snelson@pensando.io>
 <20200929221956.3521-3-snelson@pensando.io>
 <20200929171521.654fdef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ace43069-fb8e-a4e8-af96-30d59c5e86d3@pensando.io>
Date:   Tue, 29 Sep 2020 17:17:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929171521.654fdef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 5:15 PM, Jakub Kicinski wrote:
> On Tue, 29 Sep 2020 15:19:56 -0700 Shannon Nelson wrote:
>> In one corner case scenario, the driver device lif setup can
>> get delayed such that the ionic_watchdog_cb() timer goes off
>> before the ionic->lif is set, thus causing a NULL pointer panic.
>> We catch the problem by checking for a NULL lif just a little
>> earlier in the callback.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Hah, I should have looked at the second patch :D

Am I making my patches too small now?  :-)

sln

