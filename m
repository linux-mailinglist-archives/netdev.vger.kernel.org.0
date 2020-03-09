Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3947317D81C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 03:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCICWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 22:22:08 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:39069 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgCICWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 22:22:07 -0400
Received: by mail-il1-f193.google.com with SMTP id a14so4157287ilk.6
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 19:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=thE06ssyKUUC43ahFFbVqEuYSByVCmBlf/T5rChHd2A=;
        b=fHI6QL5FrfRRIJqVhiQEwqsvODKZoXs0KOx9I2acOVJOOBhprVuyZjfwVXi5xcvNSo
         tbQigo8l5VNnZVse7u4pXY42eVNbUEOaciO4vful6xQYy6XXa/T7FXWQGiGo9oaWBbOi
         8j80jZjYfOdhW+U5eaamkeUAH++KSXHEMN44W1uJ3KF9mwDIsrjPhFIO7KsYCSCTITTV
         kNN/OuV2GTGsA8nh2gdlDI+rrV0ZZJH9kEFpm8Fw8gsuO12557ki8BVmsbEcozsqicHA
         1fmO9iYOf6pEM76i20eEKYJ7NqS4lPv8vRvgcXdsc5iEUxS3fFLd2VdaNYlwo1KGWL5x
         Y7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=thE06ssyKUUC43ahFFbVqEuYSByVCmBlf/T5rChHd2A=;
        b=f5WuLLUISt1bO4J6rblmhn9QvU0PEU/oqMwzKzIGMxyft1ZXDeeHQc8uvlQaaCSBa6
         5DMETWt95fE2XzX6n1v2+uJMb7hzXd02NaWWA9qz8siyPD1+p5exb43rv1Ii8PtOCXGL
         P7SXnUZG87YLeM5vudKlywv1zqvc2z2NZT4+diyq6XoWh6PtjdLmERlDUqrz8ETWxYN9
         hcLeRIVGlLVyr8T1xSB/GVwheIb0AEHDsMd31pFW5xY8GR/tA4+k8zY3CaB/NZhXwkjG
         F7M22bEOZ+dBVlWPD/4odcGBuPOT8C5ilq+S/ncpxMndxQdYHreSL+OTtEYxLLrvk3VD
         wLZw==
X-Gm-Message-State: ANhLgQ0sUmZ9857pr+D9dfChYdRk9EhzwdG1I3Zh1ICEkhs/XNqjp4Z+
        5gupkAbNUFGHMgGUvq6gnxY=
X-Google-Smtp-Source: ADFU+vtmcgMW7uZJkuaKOrAyy9OCKd65AD8UvHEVNF4Z3vd7m+uuSWpw0TQWeR5Z/CU3zXwuYmp3/g==
X-Received: by 2002:a92:7eda:: with SMTP id q87mr7445345ill.179.1583720527039;
        Sun, 08 Mar 2020 19:22:07 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:54d7:a956:162c:3e8? ([2601:282:803:7700:54d7:a956:162c:3e8])
        by smtp.googlemail.com with ESMTPSA id z23sm7439766ior.26.2020.03.08.19.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 19:22:06 -0700 (PDT)
Subject: Re: [PATCH] ip link: Prevent duplication of table id for vrf tables
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org,
        dsahern@kernel.org, roopa@cumulusnetworks.com,
        sworley@cumulusnetworks.com
References: <20200307205916.15646-1-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b36df09f-2e15-063e-4b58-1b864bed8751@gmail.com>
Date:   Sun, 8 Mar 2020 20:22:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200307205916.15646-1-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/20 1:59 PM, Donald Sharp wrote:
> Creation of different vrf's with duplicate table id's creates
> a situation where two different routing entities believe
> they have exclusive access to a particular table.  This
> leads to situations where different routing processes
> clash for control of a route due to inadvertent table
> id overlap.  Prevent end user from making this mistake
> on accident.

I get the pain, but it is a user management problem and ip is but one
tool. I think at most ip warns the user about the table duplication; it
can't fail the create.
