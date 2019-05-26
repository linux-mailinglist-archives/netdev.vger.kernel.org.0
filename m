Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB4C2A774
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 02:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfEZA0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 20:26:44 -0400
Received: from mail-vs1-f44.google.com ([209.85.217.44]:39192 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfEZA0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 20:26:44 -0400
Received: by mail-vs1-f44.google.com with SMTP id m1so8331594vsr.6
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 17:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=QdhW0F3yImJCcBvwxVjUsZjk5FwtqHw7eVIGPKM7Ju0=;
        b=q4hKzWo88x3d8/bc+V3aOXe55UZ6T9OABb3nvmZECohxNoPgrD6yJvNmNUJp2LrIE7
         EYUtYF76krd/U4MRbRFAThEbB+5EKucl/fuTZe+qhZLiEKNYtG1mh8oNVtx9DIqOOl4W
         3dAHVc/lPT6/gVbERfH9R+ksbadz1cLgi3GvLHaYg+PoOxallmX+AvodX5dX2i+FDq0s
         MMUOz0gYcPkNTYDfPPCrKyMmRKp/EhS97IP0K4Ds73dkTZP5924F3dDskkeypfz3ZTcM
         qI3b5SvCyIW2rlN5pusQGvTvhM+Wj/j8+ZRjztVQcHDbxIpuhOl8jvwsNca5Dv9CZQKD
         kdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=QdhW0F3yImJCcBvwxVjUsZjk5FwtqHw7eVIGPKM7Ju0=;
        b=ZKH3ra2iKfw1Dg8nBmBv3bILlkVVt7SzLlOhISbdwiaVGUVWtvIS/gHV/QxZhHW0OI
         5CyCRIgXhrPc3mU7pMRPukqSfGYlQbUsEuYG8/9OshWr4Da8l2PMyeFDd2AtHodp5pQO
         Jt0iQcSKQU7cruY3BsCMoOznSvx7O4R0sb3HKUKvV31htIU11pvojImvWsT+ar7w0GrO
         7veiaEG/e1LXxgzYmfY5KRPJOI0KWufQz2uv60VnTTaVcFSCMcXq8/6sZOljGNSMHQ1m
         bs0eomn3iv+jZOqQE4pGQRgIhbl61v6o4ARPu9dEkm5RKcUUeK38+TkFfn/ky6KU30OV
         XtMw==
X-Gm-Message-State: APjAAAXUU6uK6ncp+2fubG10wMR/BdBbVJ+Q0v2V2fkB4X1AYrCMFuHG
        KX3VV7k2X7n5xpulw/Fuy8M=
X-Google-Smtp-Source: APXvYqwRYrfhkhmxfoM45ABYja8lVqh2yY0a8QOdY8jLuwaJRFQt3HmCTEPKbdE/iLujolpZLHoBHw==
X-Received: by 2002:a67:ebc1:: with SMTP id y1mr24614366vso.16.1558830402869;
        Sat, 25 May 2019 17:26:42 -0700 (PDT)
Received: from salt ([2600:1700:ee91:8f0:7352:dfaf:4702:76d])
        by smtp.gmail.com with ESMTPSA id o207sm4243611vko.21.2019.05.25.17.26.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 25 May 2019 17:26:41 -0700 (PDT)
Message-ID: <4ff639cacefe15fac417ac1a485dd895650176d8.camel@gmail.com>
Subject: Having TIPC compiled in causes strange networking failures
From:   bepvte@gmail.com
To:     hujunwei4@huawei.com
Cc:     netdev@vger.kernel.org
Date:   Sat, 25 May 2019 20:26:39 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.33.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi! I build my own kernel, and I set TIPC as enabled long ago thinking
it was something many applications depend on. After I upgraded to 5.1.5,
I noticed lots of errors in my systemd log and that Firefox couldnt
start any of its subprocesses:

NET: Registered protocol family 30
Failed to register TIPC socket type

rtkit-daemon.service: Failed to set up network namespacing: File exists

The "Failed to register" message was repeated many many times. Many
other strange problems occured until I set TIPC to compile as a module
instead. I believe this is a bug related to one of the recent TIPC
commits.

If you need any other debugging info or have somewhere else I should
report this, let me know.

