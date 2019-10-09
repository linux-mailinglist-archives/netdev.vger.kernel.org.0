Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD472D070B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 08:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfJIGKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 02:10:06 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:34834 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJIGKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 02:10:05 -0400
Received: by mail-ed1-f46.google.com with SMTP id v8so920354eds.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 23:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=DOoAZZE9tlycIErrqq3oPhxVzEhsQBPCKBj2TA5b5J0=;
        b=ZFbaWcon2kWzxrLDD6A5WCs7k1qPToHkyGkWEsoCqJipnc8sWo0HzXUn9oTVIzqGAE
         hBd9EncJBrH4Cgv2rdEHyg153TKKOwIjAuHoR4wQNwYpRmRh6jc6IzhyhrFkEnYfAPl2
         BDBzg87R5tvbzXjCI1ISxv+N75Kzah8ffneXQhibUFKFpIUIIKFsfL170ldCVPrIcM8z
         xOiIjTgTeCMUrTkEmWT1qkp6wwJyLixPvFL868POC/2wgQGUnVcyp5BjfkKImXWvGqLQ
         tQ3YeZ4GNEtfOnHm6h+tEAtkc4rQGmHu0YrHDMoRxD1Gdpfc6wfQKWRaaIpa48S+/G+b
         FHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DOoAZZE9tlycIErrqq3oPhxVzEhsQBPCKBj2TA5b5J0=;
        b=nT+qqEMNbW/1oWFZU0VmFJiPmt5/rs9xc5dhSL+BrNgdB3MgOhKck4DEV6FdRqOclm
         FFgLySsQtMHOeOaUICOglUM1gPfSRiTK2Tr93VgnWzVlhj+svuAU1gsL/w4Uw5qnwVO7
         zDnkPHMrbBalWlZvqpL+d/Tn2NJcqsHstNXEoyhyiVVBGYRe3oJ/nP4e2j5Mf88KorBx
         INOu03A2JgmWI+qbP0ETu19Byic7OeClU5PYRhsPNkg5kBA3bt6CoC1n+/ncV35fX+lz
         XVZl8REtCd8u0F8yPP+jMQo6Opz5jdF8lX1kRdAXTi8fqWlYWSCLJkEcSIu7eBy+Wlqq
         QJjg==
X-Gm-Message-State: APjAAAX2FD9IBv7eVQO44Cpn4gG3vjEeP7eOZ+SFU3Xk/KSuzLFumz8h
        Ahbsuxf/Z0gF+J+XMh01cMAAlypN3qu1u5SvK6gySnM=
X-Google-Smtp-Source: APXvYqy2Vfn/0UqFf7KQAHBHNwtMoSCpd+rzRLQvU4yVWs78AY2zIJj/6wcDNWXAHNlBdc4ygIY1Zh5RVNeUP7eYnqc=
X-Received: by 2002:a05:6402:1612:: with SMTP id f18mr1494460edv.66.1570601404261;
 Tue, 08 Oct 2019 23:10:04 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?Q2hlbum5jw==?= <mobemhit@gmail.com>
Date:   Wed, 9 Oct 2019 14:09:53 +0800
Message-ID: <CANuct4v1GjHrkw8uwTdjzDWoq0ZVy6NY49TXT1QSO+d7eh9iCg@mail.gmail.com>
Subject: Question about concurrent accesses to an eBPF map
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Now I have an eBPF program which adds or updates elements in an eBPF
map. Meanwhile, I have a user space application which reads and
deletes elements in the aforementioned eBPF map. For a specific
element in the eBPF map, if an update happens between the read and
delete, I will lose some data. I'm using 4.9.30 upstream kernel, and
I'm wondering if there is any mechanism in eBPF which can make the
"read and delete" an atomic operation.

Thanks in advance,
Paul
