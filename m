Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6301936058
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbfFEPdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:33:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37903 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfFEPdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:33:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id a186so14339136pfa.5
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 08:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q2EsOxAXEf3P9If8xM4rfqUVqDhxA+CGfjYyOMqB1RI=;
        b=PVoll/sxOXA7RLGuyXspc4g6/Erx6W167lPndIlsbJVTF/lecssP93AUL9pIa7xlgt
         +ESUQdoxWrNVzwqMR8QYt5UYsfK0CBibS87L/f+jNBWVBtbSCEdAXyI4nfdhXoySygMH
         BLIO4u6VAxOOqu8LtqoHizMFtnBxcVWHDt6L1l5Mb8VPGCvbxQNuD0MVm1YBVjP81cQp
         RfjpixtumD7gOAM7l4o/Cy7o+Rmu3Kwlkan5qMLWZr1lfur9cxRvMnYvhnXcLWjzWbhP
         7EV1tirY+6GH9xfJRqhHc7okwwuwo42php7smV2qSuXnZx6IuXai86b9n94jCcmkprzb
         2EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q2EsOxAXEf3P9If8xM4rfqUVqDhxA+CGfjYyOMqB1RI=;
        b=JBXSGE/WGMg6a0ldK/86vVXazeT+XY50QRjLQIRRqFmJvypCCTB5Wwer9DGzL0Xskv
         LhUpG01sTRdgVVTUzg6eFvmGdYZQogr/DozGtXfekiO+szNp93Z64IlGqBV1A2k9i432
         jfS5qS4ZvQulMCk6KrXN/ZWUqfaRLjL7CuBaxrgzUxFDR47bXqI0hxVrMgwA6SmAwcpW
         EUFMKaF/RpsEthkwfr6KDOtEw2r1mi2dfNKGnoPzXUXy9ZRck0ugHAMlplhWLroMuT8y
         GAriIaY4gwi8hI2SvOpA1l4EoCBbKfi8fu7oS+UrJPSuO4ueZmubcu3GLPtNeKQE3b1K
         MQqw==
X-Gm-Message-State: APjAAAWPRR5u68UEYepoCNQ0zFom6qBik1TuyFsI8By7+9MFHFcRITvR
        EjHrnJuGg3Z8XDYlHyQ+f9E=
X-Google-Smtp-Source: APXvYqy/WoiXN4u+l34KKpg4z9XZ0sD2v9lzFqATwG59+X1E6E5GFkQFbVAkAPQyvT8cOfI/e7/FnA==
X-Received: by 2002:a63:4710:: with SMTP id u16mr5341496pga.447.1559748804515;
        Wed, 05 Jun 2019 08:33:24 -0700 (PDT)
Received: from [172.27.227.204] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b15sm5242349pff.31.2019.06.05.08.33.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 08:33:22 -0700 (PDT)
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
To:     Lorenzo Colitti <lorenzo@google.com>,
        David Ahern <dsa@cumulusnetworks.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Mateusz Bajorski <mateusz.bajorski@nokia.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
 <eef3b598-2590-5c62-e79d-76eb46fae5ff@cumulusnetworks.com>
 <CAKD1Yr30Wj+Kk-ao2tFLU5apNjAVNYKeYJ+jZsb=5HTtd3+5-Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d8022629-0359-34b7-ccae-bb12b190e43b@gmail.com>
Date:   Wed, 5 Jun 2019 09:33:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAKD1Yr30Wj+Kk-ao2tFLU5apNjAVNYKeYJ+jZsb=5HTtd3+5-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 10:58 PM, Lorenzo Colitti wrote:
> As for making this change in 5.3: we might be able to structure the
> code differently in a future Android release, assuming the same
> userspace code can work on kernels back to 4.4 (not sure it can, since
> the semantics changed in 4.8). But even if we can fix this in Android,
> this change is still breaking compatibility with existing other
> userspace code. Are there concrete performance optimizations that
> you'd like to make that can't be made unless you change the semantics
> here? Are those optimizations worth breaking the backwards
> compatibility guarantees for?

The list of fib rules is walked looking for a match. more rules = more
overhead. Given the flexibility of the rules, I have not come up with
any changes that have a real improvement in that overhead. VRF, which
uses policy routing, was changed to have a single l3mdev rule for all
VRFs for this reason.
