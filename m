Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0276B1F6DBB
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgFKTJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:09:41 -0400
Received: from mout.web.de ([217.72.192.78]:58403 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgFKTJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 15:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1591902564;
        bh=dbIwwHdiMV4teofJdCbf7Y1qEHsQkx0IKl88SrSI/wo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=XDS3iBpE3K7mXWT0rZDRMSm0cFM23l9Gtv2zuOeATb5w0fdySOxwG8JScnBbOvqmz
         ga5qxe+GOiZDOkhzBMFiMwkCz+QuBBQ/UgqOh/V8lZ2z9ejqkENKd16OcTIeyxwEfz
         HRQm3ZCtoKZ2aIssjr/n2EmXfPDuHl+eVKMGT9n4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.66.14]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MzTPW-1ix0nE1PhA-00vKLa; Thu, 11
 Jun 2020 21:09:24 +0200
Subject: Re: [PATCH v2 2/2] perf tools: Improve exception handling in two
 functions of perf events parser
To:     Chen Wandun <chenwandun@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cheng Jian <cj.chengjian@huawei.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200611145605.21427-1-chenwandun@huawei.com>
 <20200611145605.21427-3-chenwandun@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <685bb0ec-c08a-d7e5-6aa3-fb7ca842d0d0@web.de>
Date:   Thu, 11 Jun 2020 21:09:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611145605.21427-3-chenwandun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8YHVMukXKwtYmbINvs1ODICL/ViARbrtJlTIw3xQBO4k6y08rvF
 Ze7MA1QiO9gvkEO0O4aQXL8wt94e96KVc8lLIFtU3//HofcRxa16etnlGih7SNdBg/jZrWL
 pThUHRFRP0FLX1ak/V4N8SneQ4ciYSs2PuUI1mY2MEXaeU9Q7UJ7DbWDVF4szlpesvz11P8
 /D0jaIYjpCwvoxnqUxQtw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2Qd2GijSBKA=:P6G5eqoRCj67AI7GF4twfg
 qfbE5CcbxG15OL0YYhw8P3ta0R+wLOfuzQ2e2HVwQolHzcj3T+63wIXDOrBmkN/7uiuDc/eSV
 GtTJjso1tJ1RsCrQtF08vlGmGKXcg4gULcKi3hZzpdhKLoOD+WfapcoHX0n5EkziQP/jdbwCL
 d9iHb7IaXl0F6UEXVoliuCMp/s0DnHgC6eTuTO9lIG9UTre1/U8IdH4yokiS/xK6Jnaen6BQE
 eeUDYYdFKBDErQiTVX9/KEnBj9d0gZv03mIhekZNzQzMfNGtHyJll2Gw1jzt8oP8UED20V6EO
 gHVHJmzn+ZR7QzcSafn+0YFB6F7NrbWmCslW0AIjdX2Gw9sz7yTZevgjYn5i0CDVeQmujhb8T
 KIikq3F17Zw0jW7TN85AT2wwQI9e4TAxpNtT8Mf8ZM2Ja4ReMEWshf9OL7NcWXg7xlw2h2DR5
 ETcN/1DMlgObatLAXrGROyC3uhj2U9Fr1Hoea190SBEAGXATIsq158APBlUs7e049918TSskp
 V3kAgGmZkGKv76ybyTousjicQxPVllr2YgqG1qV4ONb+PCTdF3XV38/74GLlgehTF/BvQhm4R
 tvpJCneYN6P4TzrtZE16O0aDdLROD2lEhup6o9+xtYgWOy7oaPatBDSNrDczXYg4kfpbeMvYz
 IcyWpSplWQXHFfdVjirxgj1LjmIUHtxVlHDtbfxyflploYy7g3EXOzES4YEThwEwYsTinSsCm
 DbdYFhJPalgWKHxaYVQdoE+V2iE+/k4Bn2N3IHI4+RVtJAUU151v5+dDzAJ10/uy5XbWZSGto
 mESk7YvUkLZmEA4cn2JQtsLZ4hp4bxjCb1SdPFM18l/P5zEwHHNBFRLNPP8i7pRxU2Skcnzst
 fh3O7w2IssZ77ec4CwI7R6PerbeRCfiDe4LC+tAbtWpDoRmGrDzVR0LoT7zQJR3X+XY2nTkLn
 l3FExDl0XcJPLiN1ZhNwllB8zbEalD+hF/31GostLD/neITp81SQt5PMJEX3IuMArlQNe4wwP
 zhtCjaAk+fwkkedA9c5DS9Q5f8DZazTL773X1r2UreEMOSWX0keoz7q0QSOw+1RQmmesWsk8/
 v8gSjX+4iQgKB4QjWqJtcuLbia4RDI97qYMHP6AtwvJV38KnNcmPLTe0SW6/wYyh9W7XUNOuF
 7FaCs6Dfq3I3ylpsx8sYX7OGf0VpixV/0TxMy2BaMIcLUAtupZ7Hv6WeEL+mDufZ2RczQI0eN
 j7HivTZmOcrq6j5ug
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix potential memory leak. Function new_term may return error, so
> it is need to free memory when the return value is negative.

How do you think about a wording variant like the following?

   Add jump targets so that a configuration object and a duplicated string
   are released after a call of the function =E2=80=9Cstrdup=E2=80=9D or =
=E2=80=9Cnew_term=E2=80=9D failed.

Regards,
Markus
