Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429E040D539
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbhIPJBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235298AbhIPJBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B4A561186;
        Thu, 16 Sep 2021 09:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631782802;
        bh=yv/P65NUKvPLn6I6fZBzrh0PDDXSPJiG66WIrAPEy9s=;
        h=From:To:Cc:Subject:Date:From;
        b=LLhS5oBLZruJX3JmpWVk5IJo2JNurjB95S2PHKc/CjWbGOnVz3yL0gyDWBmOqlW5U
         mUrGY1dBe1BoEgWBrVxkc3HZgpj7iss+nGNQJGM1txpZL8ELg9bGll6NiJKG1u/zFO
         iYCjhBrW4XyjR4/Z8CDOyxLtzEuGaqzUA2Wuv1+f8fvvFkseQEi+g3WZC5KIRaV/xM
         8Cbck66UVwFx55O/f7tip/Txp0RtzTMqRjKrQ7pFcY2qI9nvSw0p5Bexf1yTv5f3lE
         NCPvtJdfgA4M/FC8k95UL3I5p16D9dwqkNhsQwLi/b7s4FiEAMsdTwZXaeuw1KCCot
         I7xNhLeMbVqjg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQnFQ-001qjS-5M; Thu, 16 Sep 2021 11:00:00 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johan Hovold <johan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Rosin <peda@axentia.se>,
        Richard Cochran <richardcochran@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-usb@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: [PATCH v3 00/30]Change wildcards on ABI files
Date:   Thu, 16 Sep 2021 10:59:27 +0200
Message-Id: <cover.1631782432.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ABI files are meant to be parsed via a script (scripts/get_abi.pl).

A new improvement on it will allow it to help to detect if an ABI description
is missing, or if the What: field won't match the actual location of the symbol.

In order for get_abi.pl to convert What: into regex, changes are needed on
existing ABI files, as the conversion should not be ambiguous.

One alternative would be to convert everything into regexes, but this
would generate a huge amount of patches/changes. So, instead, let's
touch only the ABI files that aren't following the de-facto wildcard 
standards already found on most of the ABI files, e. g.:

	/.../
	*
	<foo>
	(option1|option2)
	X
	Y
	Z
	[0-9] (and variants)

---

v3:
   - Added a new patch for sysfs-class-rapidio;
   - sysfs-class-typec had a typo, instead of a wildcard;
   - sysfs-bus-soundwire-* had some additional What to be fixed;
   - added some reviewed-by/acked-by tags.

v2:
   - Added several patches to address uppercase "N" meaning
     as a wildcard.

Mauro Carvalho Chehab (30):
  ABI: sysfs-bus-usb: better document variable argument
  ABI: sysfs-tty: better document module name parameter
  ABI: sysfs-kernel-slab: use a wildcard for the cache name
  ABI: security: fix location for evm and ima_policy
  ABI: sysfs-class-tpm: use wildcards for pcr-* nodes
  ABI: sysfs-bus-rapidio: use wildcards on What definitions
  ABI: sysfs-class-cxl: place "not in a guest" at description
  ABI: sysfs-class-devfreq-event: use the right wildcards on What
  ABI: sysfs-class-mic: use the right wildcards on What definitions
  ABI: pstore: Fix What field
  ABI:  fix a typo on a What field
  ABI: sysfs-ata: use a proper wildcard for ata_*
  ABI: sysfs-class-infiniband: use wildcards on What definitions
  ABI: sysfs-bus-pci: use wildcards on What definitions
  ABI: -master: use wildcards on What definitions
  ABI: sysfs-bus-soundwire-slave: use wildcards on What definitions
  ABI: sysfs-class-gnss: use wildcards on What definitions
  ABI: sysfs-class-mei: use wildcards on What definitions
  ABI: sysfs-class-mux: use wildcards on What definitions
  ABI: sysfs-class-pwm: use wildcards on What definitions
  ABI: sysfs-class-rc: use wildcards on What definitions
  ABI: sysfs-class-rc-nuvoton: use wildcards on What definitions
  ABI: sysfs-class-uwb_rc: use wildcards on What definitions
  ABI: sysfs-class-uwb_rc-wusbhc: use wildcards on What definitions
  ABI: sysfs-devices-platform-dock: use wildcards on What definitions
  ABI: sysfs-devices-system-cpu: use wildcards on What definitions
  ABI: sysfs-firmware-efi-esrt: use wildcards on What definitions
  ABI: sysfs-platform-sst-atom: use wildcards on What definitions
  ABI: sysfs-ptp: use wildcards on What definitions
  ABI: sysfs-class-rapidio: use wildcards on What definitions

 .../ABI/stable/sysfs-class-infiniband         | 64 ++++++-------
 Documentation/ABI/stable/sysfs-class-tpm      |  2 +-
 Documentation/ABI/testing/evm                 |  4 +-
 Documentation/ABI/testing/ima_policy          |  2 +-
 Documentation/ABI/testing/pstore              |  3 +-
 Documentation/ABI/testing/sysfs-ata           |  2 +-
 Documentation/ABI/testing/sysfs-bus-pci       |  2 +-
 Documentation/ABI/testing/sysfs-bus-rapidio   | 32 +++----
 .../ABI/testing/sysfs-bus-soundwire-master    | 20 ++--
 .../ABI/testing/sysfs-bus-soundwire-slave     | 60 ++++++------
 Documentation/ABI/testing/sysfs-bus-usb       | 16 ++--
 Documentation/ABI/testing/sysfs-class-cxl     | 15 ++-
 .../ABI/testing/sysfs-class-devfreq-event     | 12 +--
 Documentation/ABI/testing/sysfs-class-gnss    |  2 +-
 Documentation/ABI/testing/sysfs-class-mei     | 18 ++--
 Documentation/ABI/testing/sysfs-class-mic     | 24 ++---
 Documentation/ABI/testing/sysfs-class-mux     |  2 +-
 Documentation/ABI/testing/sysfs-class-pwm     | 20 ++--
 Documentation/ABI/testing/sysfs-class-rapidio |  4 +-
 Documentation/ABI/testing/sysfs-class-rc      | 14 +--
 .../ABI/testing/sysfs-class-rc-nuvoton        |  2 +-
 Documentation/ABI/testing/sysfs-class-typec   |  2 +-
 Documentation/ABI/testing/sysfs-class-uwb_rc  | 26 ++---
 .../ABI/testing/sysfs-class-uwb_rc-wusbhc     | 10 +-
 .../ABI/testing/sysfs-devices-platform-dock   | 10 +-
 .../ABI/testing/sysfs-devices-system-cpu      | 16 ++--
 .../ABI/testing/sysfs-firmware-efi-esrt       | 16 ++--
 Documentation/ABI/testing/sysfs-kernel-slab   | 94 +++++++++----------
 .../ABI/testing/sysfs-platform-sst-atom       |  2 +-
 Documentation/ABI/testing/sysfs-ptp           | 30 +++---
 Documentation/ABI/testing/sysfs-tty           | 32 +++----
 31 files changed, 282 insertions(+), 276 deletions(-)

-- 
2.31.1


