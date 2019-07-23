Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8D471E8F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733039AbfGWSCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:02:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44234 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730819AbfGWSCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:02:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so19799746pgl.11
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 11:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KlX8mnc2TLKGzdYuaVA7PerYYgEg13kGbXM6bN4nXSw=;
        b=djQaLMYDSvS5ovODS2W3nM9t/QQHs8PEXoTjQ3wOqww5bxOB6jjf2EvKlkBc/5fE3q
         BJjyIgQgUmj4qSXtatSBNLNHCmzSkvEYiIb+UotUf0YhghHTj01C7r+20ybsUeFWYY2E
         apbhNSfYemvuIuXIs5Ma8RWBRtklH0JsONLwwptCeU/CqOa5qpN5hpRh4fLR464kGsCR
         uvOGT6jxC6avBpOIJg7ktKk6tThvF/XQS9JyVGenM6lYOJFeCTzlfOmlZSfIub/ef3H/
         +xqDfJbZj53J7/gr6UucKldZYnWMREF+dKF3NJiMCHT+MCVaTozd76SVcQFGcamAbYeY
         c9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KlX8mnc2TLKGzdYuaVA7PerYYgEg13kGbXM6bN4nXSw=;
        b=oDVsnn7hszwF3AO+QvhXDxhsSxd99G+pHVhH6ISqVbwVUXl6WU2wMiAMwTPXv3+ikM
         BPprFGetFw+BiBr+wdtvG2Ka/2UtdPDks7qNUV8lLgEqudKq+V6y7BYJ2y7chansAMpT
         MYiLzsmTQlTPO29RCcEUf3h6vwI6xeIpo/qKs3NcXJ3jplzAhmHbPN9j65kEW7qAUzDi
         +eMKCuZLweQ0PHh+LXCbXumzD3VIiB7ZOHkB7Vcpo2k1tl3bH1VSC9ERPFsDFi5rMaip
         eTDSgv2nU3ObUxfRIhjWUHnF+ZW1c4RH97EXuFsomcU0bZdwz98mT6Hmo0ttIqM/WYtc
         T9Mw==
X-Gm-Message-State: APjAAAUbMgITwH/yZz/ayFKuOWxuVwf2pq8OZNqxCLKKEPqwBqROfsEl
        PZy4MNZXaPHjdrh+j0Ru1ko=
X-Google-Smtp-Source: APXvYqzIgBXnU6wzzkXzpwwGZURWO1rt0vC60ojlkFvbhS21CULv5JVdD3dQkiUF4DvD9dfeKE+qJQ==
X-Received: by 2002:a62:3c3:: with SMTP id 186mr6989648pfd.21.1563904933318;
        Tue, 23 Jul 2019 11:02:13 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z6sm15486251pgk.18.2019.07.23.11.02.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 11:02:13 -0700 (PDT)
Date:   Tue, 23 Jul 2019 11:02:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED
 flag
Message-ID: <20190723110206.4cb1f6b1@hermes.lan>
In-Reply-To: <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
References: <cover.1556806084.git.mkubecek@suse.cz>
        <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 May 2019 16:15:10 +0200 (CEST)
Michal Kubecek <mkubecek@suse.cz> wrote:

> Add new validation flag NL_VALIDATE_NESTED which adds three consistency
> checks of NLA_F_NESTED_FLAG:
> 
>   - the flag is set on attributes with NLA_NESTED{,_ARRAY} policy
>   - the flag is not set on attributes with other policies except NLA_UNSPEC
>   - the flag is set on attribute passed to nla_parse_nested()
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> v2: change error messages to mention NLA_F_NESTED explicitly

There are some cases where netlink related to IPv4 does not send nested
flag. You risk breaking older iproute2 and other tools being used on newer
kernel. I.e this patch may break binary compatibility. Have you tried running
with this on a very old distro (like Redhat Linux 9)?

