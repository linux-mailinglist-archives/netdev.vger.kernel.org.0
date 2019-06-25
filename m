Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C05352714
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbfFYItp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:49:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54090 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730827AbfFYItp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:49:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so1919810wmj.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KOwvda9mCySGzxeHFCEgnBrcwzzjWE8WcN0MIHLSctw=;
        b=hizWZE0J7L3fS4pqVZBI50tHlG9IJ20tDww6p0ZRz/uteEDyQn5/ane+nybHMabTDu
         ilVUqfny7saGNr5XIFBOO9vZ/bJozjkLE3cxJteLZl4eNrIeAsNHmPCTCEAaDA5AxFjW
         2TB+lomNU4Z54Yz+vTAYM+mMTgSwNU9RWbwiCrKerkDDDiuK7qWQvw/AsW/2wM/WItJr
         PL/Rw4m7qo4BBBY28DRSsLsMWUDgL9iTsv3sN7WNpBSSwwWpLFKqTKNWEf2uTKEw2NG+
         zRIkvnUqLQbSLYTOk7g+BQsPcn44N39MUn1STLlDz5J49ESFP4Bl/jSEaqwlVaXQoyK7
         8L7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KOwvda9mCySGzxeHFCEgnBrcwzzjWE8WcN0MIHLSctw=;
        b=C4D2cmTelZ0bSJdjjEI4VcktMrf1m9RYYT06Xi2HeMfGnJU68GrlpPBtLX6cz9spjZ
         7iK8rU0qK2KirxXPQIOp8iXc3fw/pIkOE9DTls3096+gfXzVole69jyyHhjvqgBmyEsN
         +U19bL7gixSPAOWZq6zHBwKPtLkSGUrHPF6xuKbuBQcbEd2jsfF+wkAR8MmfLsnoA/Tm
         Q2puhvlDrzA08mX8JWDWPsMJ1sz6Q4NPVLMgsQev3JmfrAXK2BmyCQq7NKjIo0x+IJmp
         TTED4lrhH6bCV0FS3rL2x4dQ+Oghy5ClvjdOIVpeVaFqpcah2YIXTwgK2G2KneIoal6C
         B0XQ==
X-Gm-Message-State: APjAAAXXDkg9elVAJ/Bn2k1FEm3hNtwiDlmUNChfuqAadglct8A0ln0V
        rQDLeDfiLNEYrwz0QZat/JWk+g==
X-Google-Smtp-Source: APXvYqyn4NmQbXvreMW+8yAcL54D3dNlbO1iU1PHEr+cgsd1ShI2EkvAcuEapZFsWjVDejQEWAVs5w==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr19345705wmj.89.1561452582834;
        Tue, 25 Jun 2019 01:49:42 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:4dd1:811d:80c5:4a03? ([2a01:e35:8b63:dc30:4dd1:811d:80c5:4a03])
        by smtp.gmail.com with ESMTPSA id f12sm29452526wrg.5.2019.06.25.01.49.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 01:49:41 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 1/1] tc-testing: Restore original behaviour for
 namespaces in tdc
To:     Lucas Bates <lucasb@mojatatu.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com
References: <1561424427-9949-1-git-send-email-lucasb@mojatatu.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <2d79f013-903b-3305-0379-a272060168ba@6wind.com>
Date:   Tue, 25 Jun 2019 10:49:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <1561424427-9949-1-git-send-email-lucasb@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/06/2019 à 03:00, Lucas Bates a écrit :
> This patch restores the original behaviour for tdc prior to the
> introduction of the plugin system, where the network namespace
> functionality was split from the main script.
> 
> It introduces the concept of required plugins for testcases,
> and will automatically load any plugin that isn't already
> enabled when said plugin is required by even one testcase.
> 
> Additionally, the -n option for the nsPlugin is deprecated
> so the default action is to make use of the namespaces.
> Instead, we introduce -N to not use them, but still create
> the veth pair.
> 
> buildebpfPlugin's -B option is also deprecated.
> 
> If a test cases requires the features of a specific plugin
> in order to pass, it should instead include a new key/value
> pair describing plugin interactions:
> 
>         "plugins": {
>                 "requires": "buildebpfPlugin"
>         },
> 
> A test case can have more than one required plugin: a list
> can be inserted as the value for 'requires'.
> 
> Signed-off-by: Lucas Bates <lucasb@mojatatu.com>

Thank you for the follow up!

Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[snip]

> @@ -550,6 +614,7 @@ def filter_tests_by_category(args, testlist):
>  
>      return answer
>  
> +
>  def get_test_cases(args):
>      """
>      If a test case file is specified, retrieve tests from that file.
nit: this new line is probably a leftover of a previous version ;-)
