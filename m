Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9EFAB1DD
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 07:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392236AbfIFFI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 01:08:58 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:35007 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391415AbfIFFI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 01:08:58 -0400
Received: by mail-io1-f46.google.com with SMTP id f4so9261477ion.2
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 22:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=sMilIHMF4fpUOkrzUe8cvklOJJEgJVHjwG1qkNhpUVA=;
        b=IgShtlqMgpZmZIdlmtsPNbsPLaczYl3b8CV/GbMswsm5aNU8wjlLA/xiXJ7v0nk3iu
         KJKQfPQCLaEANvCtoblv0HND9L0nwUZNHg9J3cz/9W/Mc40Tgu2gOV6fXXh9wDOs2qAs
         Kq49RXSJMlAIYk0qfouJYWD2ovg2tMVCbNHARC6HDg459eq4GR6lZSoOqcRrI3Ljvm9S
         kKkPqMrtpDT0m12xKjNJvIKCwI/qrtjrR8eI+P0a+euZqEndIFceXmNVyrjYL5fXDap5
         tyyvF2Iy4OJ0SO/wyFkcpmWIjjMdFu8zZyh3LyE4/VJDpHD5aCwT0yMTPAJbUu3cmUdf
         3yOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=sMilIHMF4fpUOkrzUe8cvklOJJEgJVHjwG1qkNhpUVA=;
        b=JXEA0IDsUYuenIz5K5D09aRXB1dlXgmnZkRRJn497hCe0cNtq9klkePXJJfLIIo1Pa
         iBs0GxWWJIimHJodE+hlzRMhWBMKNF6NlfJj9PaS/VuNQqqT25IvV9NVUK6fHjDEAXwm
         Gtiz9YQ4noMs8583ilkR5E94WaT9b8lkXlrnKY5AgDxgGnsADdWE1Kv3YhRP1xQDF6hw
         BuTFkYlC/IawUxPeF2N35mkUzyKw2CWqZc1mWuVLbE/SGhQo3u+XDP4NXLAuxir+a58E
         sj9UEiH7MUrKqFbS26iWrdhRevnbhB3tLSrjYgjSrgYoywMSNsHr9gfBsibbOmwb/n6w
         i3xQ==
X-Gm-Message-State: APjAAAUtECB7ay4JOGuVoUiLfiUmUsGZP791OluM30snqOqZ4wK5OEKl
        3SR40lUNCj0AALHVMuyP5Vo1yQ7sQPPzpzQ5c7uyyCc0
X-Google-Smtp-Source: APXvYqyEqv1gBDZU4Xf1tHtN3iRtdkNSLY01KbcTol6l4PwveUokStT5A8NbBEN4BPMSFUAE8986wSw8khaVlgMjUFE=
X-Received: by 2002:a6b:6303:: with SMTP id p3mr1985667iog.169.1567746537220;
 Thu, 05 Sep 2019 22:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAMvS6vYbphKKM4evbV6Vre7vaR8r+oJgZ8TuQU6VtBSjVqH7dA@mail.gmail.com>
In-Reply-To: <CAMvS6vYbphKKM4evbV6Vre7vaR8r+oJgZ8TuQU6VtBSjVqH7dA@mail.gmail.com>
From:   dhan lin <dhan.lin1989@gmail.com>
Date:   Fri, 6 Sep 2019 10:38:46 +0530
Message-ID: <CAMvS6vbeo5tBADNmLvkXUuSSHmxVpt3UW+jZtxY2Le9nXRbNDw@mail.gmail.com>
Subject: Need more information on "ifi_change" in "struct ifinfomsg"
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

There is a field called ifi_change in "struct ifinfomsg". man page for
rtnetlink says its for future use and should be always set to
0xFFFFFFFF.

But ive run some sample tests, to confirm the value is not as per man
pages explanation.
Its 0 most of the times and non-zero sometimes.

I've the following question,

Is ifi_change set only when there is a state change in interface values?
>>My application is not interested in processing the netlink messages without any state changes.
>>Can i add a BPF socket filter to drop all Netlink messages with ifi_change=0?


with regards,
dhanlin
