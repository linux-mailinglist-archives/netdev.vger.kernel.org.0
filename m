Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C03A3AA4
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfH3Pmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:42:50 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43285 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbfH3Pmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:42:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so3529664pld.10;
        Fri, 30 Aug 2019 08:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=IZK133rvLPFOXdT1nth00dyTGLOoSKiaU2rUxXtqO8Q=;
        b=VuTxARF1T1QleDYqDcJQPzhgXTCw85eSxY26+Hh1yCqIy1SHUspXMjuo4l1TGA75SV
         BZm+4WBy3aWO640xWNGhPEy5iQ+9pLhylJgLWHMiSR/5INL//0NTDt1ug+tSe1d6eKzS
         yTPBxQ+3QfNTnVGMBDqlsScJBX0lf0nvF5Kl8k7ejc9TUf2o+ByIQD0CmZBrp7wgcRrp
         bo+FR4t52pCGDQTSNqONEubdog44dYtFf/ClX8X4M3hWI3b1zDlJj78LJnC2+j6AVG10
         ACDvKLcWRNAy0uz1a/41CWLPIj+8FXB2smJA2JjmYdYFl0JlvTQlXacNc51FEJlSZHQ3
         jv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=IZK133rvLPFOXdT1nth00dyTGLOoSKiaU2rUxXtqO8Q=;
        b=R2JC/Hs0gexCmK1SCgAdqCw21nNGf0RB/HstbrPdwrco0ftIJuyw8vsB13WDVSjmlz
         UH0l7ojinTMLce8t4OeQZLpHwQfUh/BnBsWZIdM09/kKb3RT17QFeakZSbJ5dAZc6S+w
         6D6HHP1NlR5UrqXleF0S7X6YAOaXwY3tiD+7z4uqmw+IzB5Eh36ha3xGF1M2+k1SXxJy
         4n9i/SgYvz3MyvbNIWKoI7ok9mOp3UZjt9Ev3kqbHOJMNwbbyKBGyquqiUK+6tk6uCP4
         oy8lxEc5C/xBbcRoiLxYmhEoSoDzkxGs3BsUF9TwGyRgLafOrO4eJbK7fh62+nLftOu7
         L5kg==
X-Gm-Message-State: APjAAAVMgsax5a1AOVy5tIL2Z5GhwvZIP5u0KI65rk3nedN92t/a+PM1
        WfB1A0Zit14c+hQxBYv+L14=
X-Google-Smtp-Source: APXvYqw/+bPQywjqon9wScZJzLXOScWoq0YFcZPuTDgX6BIFmkMdLuno9VKUxorEGVTYjPCRq2Yk6w==
X-Received: by 2002:a17:902:f64:: with SMTP id 91mr16367396ply.334.1567179769383;
        Fri, 30 Aug 2019 08:42:49 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id d11sm8579760pfh.59.2019.08.30.08.42.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:42:48 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 05/12] ixgbe: modify driver for handling
 offsets
Date:   Fri, 30 Aug 2019 08:42:47 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <14CCB060-4354-462E-BCCD-F6CE7A02F688@gmail.com>
In-Reply-To: <20190827022531.15060-6-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-6-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> With the addition of the unaligned chunks option, we need to make sure we
> handle the offsets accordingly based on the mode we are currently running
> in. This patch modifies the driver to appropriately mask the address for
> each case.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
