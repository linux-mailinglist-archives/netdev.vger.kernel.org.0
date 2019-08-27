Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6869B9F2BD
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbfH0SzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:55:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41727 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0SzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:55:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so14681670pfz.8
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lKlRh2dxe/EHA3VshwcUDJ/ApQ0GZca3L6AxjQGBXKY=;
        b=VRKapsMPc6jtWi2IwTY0d3oN+bY2SIj+k2+WxlfMGo6fhZ38RUyKgLcyziI7doG250
         Z4HuPktkG3Q6Jc2ZhuiS9IBYlWb67VQwuOVazhaPScFcQC22QVhvYQx9mY/MPiBhhEPr
         AuE48EY6jvM8XufLbjI2yIDdXtsR7zqef8y9Sf4kcmoj3EXUTEnjzSObGV1J4xJ3dOJs
         deppbJE7cx8ohOSUL/zgwhzO1fBJ4HLj1YgCw6dXuAUhSN/+U4DvzQxjQGo/4OSqj02Q
         sPqA2K0CHvd0JX7dkNM5VDBAU3dgWkyZDEdeW4U3kQTOwz2C2SbTlsNw04bTkqd9VEhr
         ynsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lKlRh2dxe/EHA3VshwcUDJ/ApQ0GZca3L6AxjQGBXKY=;
        b=l+rXhGf4CbmOnGvdVVV4N1Ujyn9WU1F2vuQRW/uakkmYZvWMNlGv2/gAaxqLVMBS6s
         HbgcRFW0ANOMeT3ht4ndp9NliK7PsvkMm2B6LBjcQtJfUolWvw7+FUXi5r97dDQxJBzE
         bAP6aCUUv22wQhi7c65oxefE8su/N3spcM8fvJwtJj3yMF23d87Rlws5ueHDBziOAT1u
         TVeb5Umb/wAqYeafzhijuGrbbcN0IYwTknPULd0mXmXXTGhuMZXlDTJSrEoJNAoXozLt
         Qf6WcXV1M92944kjU8Z1uqizto7qTE+wcvki46lRBlnTv523Qv6I8GmenZUWKJl5xk8c
         +NcA==
X-Gm-Message-State: APjAAAXaYLwEB4upt96+DSJkHbgCCyz/eogT9K3P9Se9gkKnjdsGvfuO
        +BKbzqUs0gPjM35sPLzCpVnBmsLk/S8=
X-Google-Smtp-Source: APXvYqz1MsmnGTGip/MbYL1V+d8Pk5r/CNmfctBfz9wP1JivIeld+YZ5nAlma9QgpK89+cviAGVmFA==
X-Received: by 2002:a63:be0d:: with SMTP id l13mr22443140pgf.357.1566932109865;
        Tue, 27 Aug 2019 11:55:09 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id o9sm132907pgv.19.2019.08.27.11.55.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:55:09 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-2-snelson@pensando.io>
 <20190826210615.6ce3631e@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <c4d40b83-131b-3aa9-22b9-c517200bb782@pensando.io>
Date:   Tue, 27 Aug 2019 11:55:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826210615.6ce3631e@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 9:06 PM, Jakub Kicinski wrote:
> On Mon, 26 Aug 2019 14:33:22 -0700, Shannon Nelson wrote:
>> +struct ionic {
>> +	struct pci_dev *pdev;
>> +	struct device *dev;
>> +	struct devlink *dl;
> No need for the dl pointer here. priv_to_devlink can be used to obtain
> the devlink pointer based on priv structure address.
>
>> +};

Sure

Thanks,
sln

