Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A280B799C0
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfG2USC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:18:02 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:41196 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfG2USB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:18:01 -0400
Received: by mail-pf1-f175.google.com with SMTP id m30so28593114pff.8
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 13:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lHJMnxl9MoXz7n5jWjbSx3gwvXltLqX9GTLV/nZ/mjA=;
        b=Uch9uOZlbKmyIDN8OfGZbgo6JM74fE4AgSF3it9ajvDJbROa/+KfJTyBDyTbHTeqLk
         wKjsKojXmt8kJHe6uxu8s7peYz4r17URnPerG5qTt5MReC31McxCMIbQBF10IJ9T+JYs
         cszLE1b6eoQd1jsCLSj1HY4rk6pOEylVX/0YzQ6/XN+PA0LnQYNFFasLSntpeohgXWWu
         98zoU6sbhHRrnwohpzpVyslM/GMO2xMnnWEQwU3dD1YQbWoUq+9EvhCAjt7MvBU+2JJk
         Yy7mrx/ixhTVcOjBM1ULsrMV3M6qYohk0TmjLZbTrx2NYQq54zLiRMQc0JcGWZfsgcep
         TWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lHJMnxl9MoXz7n5jWjbSx3gwvXltLqX9GTLV/nZ/mjA=;
        b=Fw4RApBwVbMZjVA5uUfiIban6YGUrTKbkwh/F6czJqIVKr2tI/8R1fJku0meghsheq
         cxV2Xl/A0exN4kEi4a7I+86Tep7CM9V5ZhNXNHFBfz25jlVPQTuL3xApIqUnAOFr14ce
         LVAPvJFn0kozritcuLHJFjs0AHobJoSon1QBN2ZqojCahAvOyvc27qhTRbA+PZYQKQxo
         d0cI50onPyXlzY91dQ/61c7Bp8PzTRdfZcabUWI2Sn9PFre68JwKMJAhvt7Jx0n/EKqR
         Dv30qUVphqnlWcqe6+mMdtqbLqExXHsJkx6IayvcTOkYRSDOTFs5+kEz8HjHKH9WZ2JJ
         1YSA==
X-Gm-Message-State: APjAAAVbysDCmsfReKsWBO8GOQLmB94tqlWorna2FCJ0nZ6PDwItdZA2
        FKsPMQINJmL/a4o3wckQfBE=
X-Google-Smtp-Source: APXvYqxH8EB3MDH8LouCBRHnCANxNHmQlHzdWOCfTzJgVMEU2Z3odIPtfl7KFtyEzoUvJxl9JubH2g==
X-Received: by 2002:a65:6152:: with SMTP id o18mr102118417pgv.279.1564431481222;
        Mon, 29 Jul 2019 13:18:01 -0700 (PDT)
Received: from [172.27.227.219] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id w22sm66900028pfi.175.2019.07.29.13.17.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:18:00 -0700 (PDT)
Subject: Re: [patch iproute2 1/2] devlink: introduce cmdline option to switch
 to a different namespace
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190727094459.26345-1-jiri@resnulli.us>
 <20190727100544.28649-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <db479059-0dc5-63b2-44e2-5628a5d2d4bc@gmail.com>
Date:   Mon, 29 Jul 2019 14:17:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190727100544.28649-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subject line should have iproute2-next
