Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A13EB1326
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbfILREA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:04:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42135 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbfILRD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 13:03:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id z12so2241254pgp.9;
        Thu, 12 Sep 2019 10:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yxeo5HbGYSNnNlmIUmYsnSAfEu60Tsbupk7acpSzF6U=;
        b=jdWYr4vvW6MczaoNh262ZaSYPcKm4ygJ7xTFoNueOfVJwPk61fugKYK7PvnzPhr7BA
         Gmm6IQfegGnupzjNt6v3tAuu+/peeMCCQDXZzY3iTUAM098xqxTrffbWltY4DQfMdij8
         ijCyVRkhm2/AgSz1zjYXXW/4++7NDNfvHFprbuxLEynOBmQ7KcwntEbrqxcGCMXMSbaG
         130+4uSJTgI4MGwRiCxZLc+bupK49t1C+ytkXlZaWLil2MBPAiDJxBfxn507bj11CCoc
         /SlAfOilbUvGx7jl+Y3jx/yTEhdA6rjzZkIgZ15F9jUNno1x1+6iO/Fuk5izqAHa4vSU
         Mlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yxeo5HbGYSNnNlmIUmYsnSAfEu60Tsbupk7acpSzF6U=;
        b=K3uqp9rLFjas7oV33JaXG0OqUTg9BL3KmWW4djT7FXUMWs019DEkY2CKA3OnVj7h23
         IsAc8sdRsgwhKK1bAC1pycYKjMYSmc36s9X6ptdwvgqaxBLh+r86KA0/mgNbcYJUhsY0
         4yTPO8Reyv+/H1FAZMCEmh6IrMBOOw0PLd02KzPDaPaBcxG/T91+mb7wdS6pezK9jRrI
         eMptO5IQ0XtHf9lRMfYSAhbp3IreRYV2ltMU/X2zuxkgc4W5lLtFcyYGvd9Zi68amJxE
         dfVmKzPegPas2jBYKW8vXbJNnqFZp0YMM0dm+aX2dBCyV9uRKA7GnxlG5j+GHPQC92Vu
         5Xwg==
X-Gm-Message-State: APjAAAWrDgEsvUZeTOZD70YiaRvagPHSESTylk6i2QDUWQJX/Axy63v2
        wv9JDI3i6/6SmpennVBzW14=
X-Google-Smtp-Source: APXvYqyciIA7Z3P3LeG9OsX5mO7OvEzqZCcyWrKVXpE9M8cYnzDkNcnQ36TayyHLK7x/t1hYzptNeA==
X-Received: by 2002:aa7:97aa:: with SMTP id d10mr50878218pfq.176.1568307372122;
        Thu, 12 Sep 2019 09:56:12 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id o22sm392845pjq.21.2019.09.12.09.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 09:56:11 -0700 (PDT)
Date:   Thu, 12 Sep 2019 09:56:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 2/2] PTP: add support for one-shot output
Message-ID: <20190912165609.GA1439@localhost>
References: <20190911061622.774006-1-felipe.balbi@linux.intel.com>
 <20190911061622.774006-2-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911061622.774006-2-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 09:16:22AM +0300, Felipe Balbi wrote:
> Some controllers allow for a one-shot output pulse, in contrast to
> periodic output. Now that we have extensible versions of our IOCTLs, we
> can finally make use of the 'flags' field to pass a bit telling driver
> that if we want one-shot pulse output.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
> 
> Changes since v3:
> 	- Remove bogus bitwise negation
> 
> Changes since v2:
> 	- Add _PEROUT_ to bit macro
> 
> Changes since v1:
> 	- remove comment from .flags field

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

@davem, these two are good to go!

Thanks,
Richard
