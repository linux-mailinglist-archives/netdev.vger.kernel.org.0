Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F6E56D98
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfFZP0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:26:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34263 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfFZP0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:26:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so1552161pfc.1
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=o8AhiI/i8o8vwYbTU0b/a4F0hNwr6f39pwk0IhN+B0o=;
        b=HnVsaiIA+c8BUux3sVL2u9yRHlsWYgHW/wqanPPPJiqOWhMySSjAbXqZtFtls7fiD7
         r59C4Oth4r7IQvwu9u3x12MznAbURpzlwZjHju1fq2knCkEA9SF/ymVPcyvekTONbxbh
         egG7t4O4+vKdxV7UkZPy9mVFV5mOm85kuQ7hIXW7MKmvT4IQQqnbwq7iv5FBYTo4gIUV
         9grL6U0wUssCiQrlmX26UZt+GaZZcNDxnKFB9WSpYCMvqwh2527NnfZmrJkfbWNSXiwC
         71fnBUsCuxiwAlmbXQVGJrCVSwlRZukkFDOUAxddxc16pIPDJKPvGVjZAVo8WdqT7LDz
         Fn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=o8AhiI/i8o8vwYbTU0b/a4F0hNwr6f39pwk0IhN+B0o=;
        b=EX1tDGgypfNmIvhXEf4CNXlLkpkmJKe2AUFpLvzvLFsl4oGJl8kEN2L4AiJY9rXTe+
         oeQECaqHR+ezL9G+Kekb/U0PusXdXPKwid0dMnVCpz36MDqTR4qFGpxKXB7cauxWsXB+
         8/7MwriKcHnQf1a3rPKPWc68UwNKwQQpJbIX9H57y3OOZ2LjhfkqQi7CKa8adUSnjlIP
         /2btBuldSZE9gyl1awiK9X6+MXlFYTt7jgGxYZu+LM0287hH9nzRsPxMgfKaOjc9yK7a
         9T4+upJrlpF7q3VUBAEpQMo5qyylDzPmOae2M3caZDvGb28mnS9NHxZ+UtmYbPBmtdY1
         N8jQ==
X-Gm-Message-State: APjAAAWw8DvXcErP2aPG1O5mSDTxP8Li15J556LO/ojvoERTu0SvLu/n
        0jZoPGOabg+MEM6j+eIlDVIm/RBYNmk=
X-Google-Smtp-Source: APXvYqydYnVlpdhPep01Y6s/Y1eKIDZ7qvkwcKN78O2zTaLyebyB6yKxFgGhNSz+SMw1P78mLN0/dQ==
X-Received: by 2002:a17:90a:be0a:: with SMTP id a10mr5167557pjs.112.1561562765175;
        Wed, 26 Jun 2019 08:26:05 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id f64sm18008432pfa.115.2019.06.26.08.26.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:26:04 -0700 (PDT)
Subject: Re: [PATCH net-next 08/18] ionic: Add notifyq support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-9-snelson@pensando.io>
 <20190625162100.77a81054@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <794c80a9-e256-62c1-dead-6171758e9500@pensando.io>
Date:   Wed, 26 Jun 2019 08:26:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625162100.77a81054@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 4:21 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:14 -0700, Shannon Nelson wrote:
>> +	case EVENT_OPCODE_HEARTBEAT:
>> +		netdev_info(netdev, "Notifyq EVENT_OPCODE_HEARTBEAT eid=%lld\n",
>> +			    eid);
>> +		break;
> I wonder how often this gets sent and whether the info log level is
> really necessary for a correctly working heartbeat?
Now that our FW folks have just recently settled on a proper heartbeat 
mechanism, this will be removed and replaced.

sln

