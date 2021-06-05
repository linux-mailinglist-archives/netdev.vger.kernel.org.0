Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D187939C8E3
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 15:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFENjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 09:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFENi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 09:38:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C23286135F;
        Sat,  5 Jun 2021 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622900229;
        bh=vVFuxJcc2zxGSbB7UdD22Ei/qbdSpSclZeHlTn/3YhU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YvYT6g2uMiGoR+6sy8adxF2RKOKdLfZwZM1lQ2XSeGEmVRPfj+lL9GfMuDZZyN5sW
         owde4vG3yj7p7pLXeq7cT8Quzu5K2oje+SVTkxIFZzcqSZ8hnMEW22eBk76FE287fo
         4UO5rHWF2ckQlxw3LXeqP9dl2lb4h/WYP8nTAjJYJK6XJoYk/G411kYe/F/2iQJhoD
         xXRTDbDCKLXwoKXPmi6Vr+WyuZ3ew8qcXU3FezEQ7yPGxTwls2XhX7YcBJMW4KIq4h
         iQEMQ7FEZy5AfH5qZZbVs3RolIS66jPxDTIm3nQXafdQE5dr92NhDgnKsUXTMjPJ2E
         9HOoolYpwluWw==
Date:   Sat, 5 Jun 2021 15:37:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "Jonathan Corbet" <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        coresight@lists.linaro.org, devicetree@vger.kernel.org,
        kunit-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/34] docs: avoid using ReST :doc:`foo` tag
Message-ID: <20210605153701.56a8e2d8@coco.lan>
In-Reply-To: <cover.1622898327.git.mchehab+huawei@kernel.org>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat,  5 Jun 2021 15:17:59 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:

> As discussed at:
> 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
> 
> It is better to avoid using :doc:`foo` to refer to Documentation/foo.rst, as the
> automarkup.py extension should handle it automatically, on most cases.

Forgot to mention:

1. this series is against docs-next branch;
2. maintainers bcc, as otherwise the e-mail would be rejected,
   due to the number of c/c. I opted to keep c/c the mailing
   lists.

Regards,
Mauro

> 
> There are a couple of exceptions to this rule:
> 
> 1. when :doc:  tag is used to point to a kernel-doc DOC: markup;
> 2. when it is used with a named tag, e. g. :doc:`some name <foo>`;
> 
> It should also be noticed that automarkup.py has currently an issue:
> if one use a markup like:
> 
> 	Documentation/dev-tools/kunit/api/test.rst
> 	  - documents all of the standard testing API excluding mocking
> 	    or mocking related features.
> 
> or, even:
> 
> 	Documentation/dev-tools/kunit/api/test.rst
> 	    documents all of the standard testing API excluding mocking
> 	    or mocking related features.
> 	
> The automarkup.py will simply ignore it. Not sure why. This patch series
> avoid the above patterns (which is present only on 4 files), but it would be
> nice to have a followup patch fixing the issue at automarkup.py.
> 
> On this series:
> 
> Patch 1 manually adjust the references inside driver-api/pm/devices.rst,
> as there it uses :file:`foo` to refer to some Documentation/ files;
> 
> Patch 2 converts a table at Documentation/dev-tools/kunit/api/index.rst
> into a list, carefully avoiding the 
> 
> Patch 3 converts the cross-references at the media documentation, also
> avoiding the automarkup.py bug;
> 
> Patches 4-34 convert the other occurrences via a replace script. They were
> manually edited, in order to honour 80-columns where possible.
> 
> I did a diff between the Sphinx 2.4.4 output before and after this patch
> series in order to double-check that all converted Documentation/ 
> references will produce <a href=<foo>.rst>foo title</a> tags.
> 
> Mauro Carvalho Chehab (34):
>   docs: devices.rst: better reference documentation docs
>   docs: dev-tools: kunit: don't use a table for docs name
>   media: docs: */media/index.rst: don't use ReST doc:`foo`
>   media: userspace-api: avoid using ReST :doc:`foo` markup
>   media: driver-api: drivers: avoid using ReST :doc:`foo` markup
>   media: admin-guide: avoid using ReST :doc:`foo` markup
>   docs: admin-guide: pm: avoid using ReSt :doc:`foo` markup
>   docs: admin-guide: hw-vuln: avoid using ReST :doc:`foo` markup
>   docs: admin-guide: sysctl: avoid using ReST :doc:`foo` markup
>   docs: block: biodoc.rst: avoid using ReSt :doc:`foo` markup
>   docs: bpf: bpf_lsm.rst: avoid using ReSt :doc:`foo` markup
>   docs: core-api: avoid using ReSt :doc:`foo` markup
>   docs: dev-tools: testing-overview.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: dev-tools: kunit: avoid using ReST :doc:`foo` markup
>   docs: devicetree: bindings: submitting-patches.rst: avoid using ReSt
>     :doc:`foo` markup
>   docs: doc-guide: avoid using ReSt :doc:`foo` markup
>   docs: driver-api: avoid using ReSt :doc:`foo` markup
>   docs: driver-api: gpio: using-gpio.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: driver-api: surface_aggregator: avoid using ReSt :doc:`foo`
>     markup
>   docs: driver-api: usb: avoid using ReSt :doc:`foo` markup
>   docs: firmware-guide: acpi: avoid using ReSt :doc:`foo` markup
>   docs: hwmon: adm1177.rst: avoid using ReSt :doc:`foo` markup
>   docs: i2c: avoid using ReSt :doc:`foo` markup
>   docs: kernel-hacking: hacking.rst: avoid using ReSt :doc:`foo` markup
>   docs: networking: devlink: avoid using ReSt :doc:`foo` markup
>   docs: PCI: endpoint: pci-endpoint-cfs.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: PCI: pci.rst: avoid using ReSt :doc:`foo` markup
>   docs: process: submitting-patches.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: security: landlock.rst: avoid using ReSt :doc:`foo` markup
>   docs: trace: coresight: coresight.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: trace: ftrace.rst: avoid using ReSt :doc:`foo` markup
>   docs: userspace-api: landlock.rst: avoid using ReSt :doc:`foo` markup
>   docs: virt: kvm: s390-pv-boot.rst: avoid using ReSt :doc:`foo` markup
>   docs: x86: avoid using ReSt :doc:`foo` markup
> 
>  .../PCI/endpoint/pci-endpoint-cfs.rst         |  2 +-
>  Documentation/PCI/pci.rst                     |  6 +--
>  .../special-register-buffer-data-sampling.rst |  3 +-
>  Documentation/admin-guide/media/bt8xx.rst     | 15 ++++----
>  Documentation/admin-guide/media/bttv.rst      | 21 ++++++-----
>  Documentation/admin-guide/media/index.rst     | 12 +++---
>  Documentation/admin-guide/media/saa7134.rst   |  3 +-
>  Documentation/admin-guide/pm/intel_idle.rst   | 16 +++++---
>  Documentation/admin-guide/pm/intel_pstate.rst |  9 +++--
>  Documentation/admin-guide/sysctl/abi.rst      |  2 +-
>  Documentation/admin-guide/sysctl/kernel.rst   | 37 ++++++++++---------
>  Documentation/block/biodoc.rst                |  2 +-
>  Documentation/bpf/bpf_lsm.rst                 | 13 ++++---
>  .../core-api/bus-virt-phys-mapping.rst        |  2 +-
>  Documentation/core-api/dma-api.rst            |  5 ++-
>  Documentation/core-api/dma-isa-lpc.rst        |  2 +-
>  Documentation/core-api/index.rst              |  4 +-
>  Documentation/dev-tools/kunit/api/index.rst   |  8 ++--
>  Documentation/dev-tools/kunit/faq.rst         |  2 +-
>  Documentation/dev-tools/kunit/index.rst       | 14 +++----
>  Documentation/dev-tools/kunit/start.rst       |  6 +--
>  Documentation/dev-tools/kunit/tips.rst        |  5 ++-
>  Documentation/dev-tools/kunit/usage.rst       |  8 ++--
>  Documentation/dev-tools/testing-overview.rst  | 16 ++++----
>  .../bindings/submitting-patches.rst           | 11 +++---
>  Documentation/doc-guide/contributing.rst      |  8 ++--
>  Documentation/driver-api/gpio/using-gpio.rst  |  4 +-
>  Documentation/driver-api/ioctl.rst            |  2 +-
>  .../driver-api/media/drivers/bttv-devel.rst   |  2 +-
>  Documentation/driver-api/media/index.rst      | 10 +++--
>  Documentation/driver-api/pm/devices.rst       |  8 ++--
>  .../surface_aggregator/clients/index.rst      |  3 +-
>  .../surface_aggregator/internal.rst           | 15 ++++----
>  .../surface_aggregator/overview.rst           |  6 ++-
>  Documentation/driver-api/usb/dma.rst          |  6 +--
>  .../acpi/dsd/data-node-references.rst         |  3 +-
>  .../firmware-guide/acpi/dsd/graph.rst         |  2 +-
>  .../firmware-guide/acpi/enumeration.rst       |  7 ++--
>  Documentation/hwmon/adm1177.rst               |  3 +-
>  Documentation/i2c/instantiating-devices.rst   |  2 +-
>  Documentation/i2c/old-module-parameters.rst   |  3 +-
>  Documentation/i2c/smbus-protocol.rst          |  4 +-
>  Documentation/kernel-hacking/hacking.rst      |  4 +-
>  .../networking/devlink/devlink-region.rst     |  2 +-
>  .../networking/devlink/devlink-trap.rst       |  4 +-
>  Documentation/process/submitting-patches.rst  | 32 ++++++++--------
>  Documentation/security/landlock.rst           |  3 +-
>  Documentation/trace/coresight/coresight.rst   |  8 ++--
>  Documentation/trace/ftrace.rst                |  2 +-
>  Documentation/userspace-api/landlock.rst      | 11 +++---
>  .../userspace-api/media/glossary.rst          |  2 +-
>  Documentation/userspace-api/media/index.rst   | 12 +++---
>  Documentation/virt/kvm/s390-pv-boot.rst       |  2 +-
>  Documentation/x86/boot.rst                    |  4 +-
>  Documentation/x86/mtrr.rst                    |  2 +-
>  55 files changed, 217 insertions(+), 183 deletions(-)
> 



Thanks,
Mauro
