Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3E537AA0
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfFFRL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:11:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37454 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfFFRLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:11:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id 20so1718024pgr.4
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 10:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VD+aymh6GZ1veAfpvpQZN9PDHAk+S4M50iwl1PJ81zg=;
        b=aLqrCOM0xuK9HqBSICwXset/9bGlFBwr9JLYAuwEECP0wb3Jdoq+UrB2brYBXpM2Cu
         DmXqc0ol3VB2gGQst6rpvBICxUEtiSz9Vwux2gOrHoeJaY+JQ9oF7tn0B+OegPwtC8Uz
         HavAoYaVt42y5D69Ir/WZK1gW6B6nPWs9VuN0/kNYprPxccAtvckhl46oV+c/KypCUAE
         QJQ+c5E5DbXhS0TsITZZNIg8tn65v07hgyXMysbArvWV9+3A8G2/jcyPU9OFSo+xYA0f
         5kFNU7JVOSjbN2sbR4FJzwWBI7myGC7/uZFdtYsY9XRBjYCjtyj/Tsp9dyFyCabRnjFm
         U/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VD+aymh6GZ1veAfpvpQZN9PDHAk+S4M50iwl1PJ81zg=;
        b=E59C5BuixMcfmC/zSO6Jqe4UD23udf95LwugJY26JXgkX6m0/PnBtS5kSDy4aCjCIN
         tJilOsXp3WkwoeFrzzf50FGt1jCkoETKf5NT6zVbAI1uTzBY+Dr/hvPfHeDog0k77rQv
         r39hV6tIoOwuTltKu/XNzZuHs4MzJfRqX+WZ3U6DutxYlZSXzMseKko7Q+O8+QMu7n2i
         Pvvt0r0rpNk0SUz3LTMOwon614wVEv8UJ7YfbyxbXZfNpyn4mERad4SiKFWoDm6gBewV
         w0uizQWizlwtZv599eN2sKyyvI3NZT3Q3ZnR4uJpa/GkFj4p1N7/r5QKCsVvfkhAB6js
         SDmw==
X-Gm-Message-State: APjAAAWdJ95JgHBLS4nyZg9cnH5hmZD8rh3NhV6WJmKknfWEdzWkQTWf
        WogsT+S5G6TXxTOgvZt9IYI=
X-Google-Smtp-Source: APXvYqwaPdMR4ExP1NfCL4a/66ZRL4WGLuLSVvMlQ5d1nTcr2XRiBu2KcNx2Xkyrqn+QmALoHTZ4wQ==
X-Received: by 2002:aa7:8d85:: with SMTP id i5mr52866505pfr.242.1559841085433;
        Thu, 06 Jun 2019 10:11:25 -0700 (PDT)
Received: from [172.27.227.242] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id d28sm2151286pgd.79.2019.06.06.10.11.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:11:24 -0700 (PDT)
Subject: Re: [PATCH net] neighbor: Reset gc_entries counter if new entry is
 released before insert
To:     Jeremy Cline <jcline@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, ian.kumlien@gmail.com,
        alan.maguire@oracle.com
References: <20190502010834.25519-1-dsahern@kernel.org>
 <20190504.004100.415091334346243894.davem@davemloft.net>
 <20190606170729.GA15882@laptop.jcline.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9c9ad9b0-d058-7f81-be5d-d37675cbd211@gmail.com>
Date:   Thu, 6 Jun 2019 11:11:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190606170729.GA15882@laptop.jcline.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 11:07 AM, Jeremy Cline wrote:
> 
> Did this get lost in the shuffle? I see it in mainline, but I don't see
> it in stable. Folks are encountering it with recent 5.1 kernels in
> Fedora: https://bugzilla.redhat.com/show_bug.cgi?id=1708717.
> 
> Thanks,
> Jeremy
> 

Still in the queue:
https://patchwork.ozlabs.org/bundle/davem/stable/?series=&submitter=&state=*&q=&archive=
