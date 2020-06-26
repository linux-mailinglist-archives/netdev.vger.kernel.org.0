Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F8620B70F
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgFZRbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:31:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43408 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726458AbgFZRbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593192696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mtoAMY2XW89vhOBgxNqGdUMLTGPUvuzF40jBdbVwg24=;
        b=LlC4UrrEN6mrXJasLzWYoM0EnKgRNMPtcmW6ZAVJYnI+s8Sc3FS5quL+Kzlr5x394wnlgL
        aEnfagkO3plYqfQ3CDzbUdeuym8sckz+v+NjSp3QwDu3fWiov0sAUVOUu645eeWWVcKj+t
        wiBby3Bezv4O8rbsHtirc9KF03ctC+Y=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-1nFvQHrMPzeiEYPZ-ZZzIA-1; Fri, 26 Jun 2020 13:31:33 -0400
X-MC-Unique: 1nFvQHrMPzeiEYPZ-ZZzIA-1
Received: by mail-il1-f200.google.com with SMTP id x23so4029183ilk.4
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtoAMY2XW89vhOBgxNqGdUMLTGPUvuzF40jBdbVwg24=;
        b=arEwUJEBUcdffBPR/q/ywg29K9UPV5U7qOmkPp4n8TE/xPzD5G/siTqXmTqWPkE9Gp
         FrrXsFFyC4Q+5XESiogVIB/sr/OQ/lZyNQodRmPAfFg24RBT2/9HZ65mWvPbPyE+Ujjx
         zPc2+RWBW+wvCrTZz58UTfYOkATv/fADME0JLkm2bbImDquAHenkrzYrHkxrIYhgFfJ7
         fV98wR4n1L1wQvYtyk5KXTOUNTBfFCh/X5LSDNMB1ApMwD2Ae6a3AQAgbp12yX/tQ1w+
         Wr2ApwD8CDaQshl1iKv+7f7nTzUZgENhRr6ZfDAK2F3cM6ozMuJdOfwdw0pZKT/f5j45
         WN5g==
X-Gm-Message-State: AOAM531HSjZZ2fbOyJp0F/pZRb6asPPjQBWOzN+ZqBpX7i3jfDsGkVFD
        weJEZ3rXuj+EwtcpC486SBLtDNfAzy4HBJ+8ZZL61lqlb1WLEdINtREBrmUA43ppopD5SRyYHf2
        2lcLvFXT+AVchEIj9345reJlzWf3dLbSE
X-Received: by 2002:a92:2802:: with SMTP id l2mr4063549ilf.169.1593192692858;
        Fri, 26 Jun 2020 10:31:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztSdTGrLjmbOoGzDJ4Bdw7tV30WuF+J5ZrNtqwIfiytW0SqHTaYb1Vm7Rb4IY5lpWkdAScMS/3eQENhghGiPA=
X-Received: by 2002:a92:2802:: with SMTP id l2mr4063540ilf.169.1593192692672;
 Fri, 26 Jun 2020 10:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200626172650.115224-1-aahringo@redhat.com> <20200626172650.115224-2-aahringo@redhat.com>
In-Reply-To: <20200626172650.115224-2-aahringo@redhat.com>
From:   Alexander Ahring Oder Aring <aahringo@redhat.com>
Date:   Fri, 26 Jun 2020 13:31:21 -0400
Message-ID: <CAK-6q+g+f7BD+C5PKWWc+1Ybd1ruTwNGa7RfogEgr4AWdKtvwA@mail.gmail.com>
Subject: Re: [PATCHv2 dlm-next 1/3] net: sock: add sock_set_mark
To:     davem@davemloft.net
Cc:     kuba@kernel.org, David Teigland <teigland@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear netdev maintainers,

These patches are based on dlm/next. Due other changes in dlm/next
there could be a conflict when applying everything into net-next. Is
it okay to get this patch merged into dlm/next? Or what is the
preferred way to get these patches upstream?

Thank you.

- Alex

