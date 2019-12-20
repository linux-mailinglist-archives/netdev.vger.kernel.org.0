Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC75127F69
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfLTPfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:35:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34902 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfLTPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:35:30 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so9690257wmb.0
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gqrF9pvmNvbyZ7iF5tr0vPsyh3BTimuOn+73jWsLZC8=;
        b=Q7CAltA8TS/OLUGuIThw79ldnl8U3YiKJRx1tVOttSOd4pg3yjWMK91aAmTcEkYqss
         33xDV7JP9D0Y4uuAyvJNp7oJoEkQCOrsPPqJq+p5yW/ZLxrtHBAzLzXc1YgDEHQuRNzw
         vN/LcxkV+fg71e0kgQAQit7TEVSd6tYcvfzEtEsFUWIF4cdxe6qht9jEO+wy7X+qzebv
         PulNNHyCFkoaEJAkNPyBCtxm1RZ7eUkWQ6TGsQEZ2hWTWB4UHXOnw9hmsvxQVaneWtn0
         fno3UssnJ3G8pzlFWi8uzJnQG2yHtS7gKC7LtC+1DxXH56bJmae5OwzKdQTuBWExWeZe
         SRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gqrF9pvmNvbyZ7iF5tr0vPsyh3BTimuOn+73jWsLZC8=;
        b=uOwph4N6ZxDGN7hHrTllFqCGzr0ETfS/tSO0QpRYaOjhu77RzYBTwWOyvJ2APux+E+
         /gJbmCiW4Ff+GgDre2s6V4tAoZXT4EghECZLClJzXeH9j9q09IAJ6+le3su5Pe+fbQTH
         +QzDAi/4wsdiGsUZ5aA4Mwt5oEgZQJVd6zVOM563t3zLOiTuF4W0TVe6y1OILDLJlOh2
         MIyeBOFA9pcxcRUSqN6LHC0V+jamlWuFhnPylxy8ip9+YkZiCPn1U0/o/S6IgWKXfW5M
         XvAjYDAOawNY5i4kpPFIFxKq4oHybplszABjvzSMLAQjjvIzdRgpMXlk2V/9FhNA0V2M
         qlhQ==
X-Gm-Message-State: APjAAAWjD5nC3Nrxg2Hmjh3fyc1WNr/XxOk1Vjr07dXx4aBBLkDA3Ics
        snc71YYwCzGCcu7MMOCKqQ4=
X-Google-Smtp-Source: APXvYqy2D/gr43+Bzk6jM85PWry336ocx74q85u3O8VZOLj/QxtKjo1YA2ImvrWO/lRUwSupKH+SAw==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr16604309wmk.124.1576856128648;
        Fri, 20 Dec 2019 07:35:28 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id q19sm9743185wmc.12.2019.12.20.07.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:35:27 -0800 (PST)
Subject: Re: [PATCH net-next v5 01/11] net: Make sock protocol value checks
 more specific
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-2-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ce72abad-ef13-ffee-8dca-0efddd1ccb2c@gmail.com>
Date:   Fri, 20 Dec 2019 07:35:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-2-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> SK_PROTOCOL_MAX is only used in two places, for DECNet and AX.25. The
> limits have more to do with the those protocol definitions than they do
> with the data type of sk_protocol, so remove SK_PROTOCOL_MAX and use
> U8_MAX directly.
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
