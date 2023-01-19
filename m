Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF3672D73
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjASAgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjASAgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:36:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D52474F6;
        Wed, 18 Jan 2023 16:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A32F761B03;
        Thu, 19 Jan 2023 00:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAFCC433F0;
        Thu, 19 Jan 2023 00:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674088579;
        bh=0bh33PVIcI1nq+AORZu9XFIWog7MKrEUcokViX0cBoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tU/x6VQkij5Hii1/8OjYzuVMVZ+fWzAQaa6ii7+VGH85Unp4pR9oNzgsQvWD5ZxE2
         YcSP5/BJS+P4CcFNbQavpMvnxezDjLFeBYqb2eYBXjLumcJcB9CIKfehf0Eh6oSNiA
         vfaKdNJo4Nhjax9o2CBTRbKpO2pwdmpBFpBhsPuYfD9lmRLe7LZp9AqF/aa37CGUEB
         WUGApTQcRNxgUbAgeeQp+urYspSRO0ePDWKycq60wzbVPytBZt7q4SHFLQa66turAw
         td+sJT9VhB9LsyP3DahihT3fk+keFfge0aFNEyBqOMxG3k1mY4SGnEB2Bpt/EdcJLx
         9GX2x1CNYdwQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec docs)
Date:   Wed, 18 Jan 2023 16:36:06 -0800
Message-Id: <20230119003613.111778-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119003613.111778-1-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation about the upcoming Netlink protocol specs.

Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v3:
 - spelling from Guillaume
v2:
  - plenty -> plenty of
  - type: unspec -> type: unused
  - ECHO edits from Guillaume
---
 Documentation/core-api/index.rst              |   1 +
 Documentation/core-api/netlink.rst            |  99 ++++
 .../userspace-api/netlink/c-code-gen.rst      | 107 +++++
 .../netlink/genetlink-legacy.rst              |  96 ++++
 Documentation/userspace-api/netlink/index.rst |   5 +
 Documentation/userspace-api/netlink/specs.rst | 422 ++++++++++++++++++
 MAINTAINERS                                   |   2 +
 7 files changed, 732 insertions(+)
 create mode 100644 Documentation/core-api/netlink.rst
 create mode 100644 Documentation/userspace-api/netlink/c-code-gen.rst
 create mode 100644 Documentation/userspace-api/netlink/genetlink-legacy.rst
 create mode 100644 Documentation/userspace-api/netlink/specs.rst

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 77eb775b8b42..7a3a08d81f11 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -127,6 +127,7 @@ Documents that don't fit elsewhere or which have yet to be categorized.
    :maxdepth: 1
 
    librs
+   netlink
 
 .. only:: subproject and html
 
diff --git a/Documentation/core-api/netlink.rst b/Documentation/core-api/netlink.rst
new file mode 100644
index 000000000000..7b98dd48a6af
--- /dev/null
+++ b/Documentation/core-api/netlink.rst
@@ -0,0 +1,99 @@
+.. SPDX-License-Identifier: BSD-3-Clause
+
+.. _kernel_netlink:
+
+===================================
+Netlink notes for kernel developers
+===================================
+
+General guidance
+================
+
+Attribute enums
+---------------
+
+Older families often define "null" attributes and commands with value
+of ``0`` and named ``unspec``. This is supported (``type: unused``)
+but should be avoided in new families. The ``unspec`` enum values are
+not used in practice, so just set the value of the first attribute to ``1``.
+
+Message enums
+-------------
+
+Use the same command IDs for requests and replies. This makes it easier
+to match them up, and we have plenty of ID space.
+
+Use separate command IDs for notifications. This makes it easier to
+sort the notifications from replies (and present them to the user
+application via a different API than replies).
+
+Answer requests
+---------------
+
+Older families do not reply to all of the commands, especially NEW / ADD
+commands. User only gets information whether the operation succeeded or
+not via the ACK. Try to find useful data to return. Once the command is
+added whether it replies with a full message or only an ACK is uAPI and
+cannot be changed. It's better to err on the side of replying.
+
+Specifically NEW and ADD commands should reply with information identifying
+the created object such as the allocated object's ID (without having to
+resort to using ``NLM_F_ECHO``).
+
+NLM_F_ECHO
+----------
+
+Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
+to take effect.  This is useful for programs that need precise feedback
+from the kernel (for example for logging purposes).
+
+Support dump consistency
+------------------------
+
+If iterating over objects during dump may skip over objects or repeat
+them - make sure to report dump inconsistency with ``NLM_F_DUMP_INTR``.
+
+Netlink specification
+=====================
+
+Documentation of the Netlink specification parts which are only relevant
+to the kernel space.
+
+Globals
+-------
+
+kernel-policy
+~~~~~~~~~~~~~
+
+Defines if the kernel validation policy is per operation (``per-op``)
+or for the entire family (``global``). New families should use ``per-op``
+(default) to be able to narrow down the attributes accepted by a specific
+command.
+
+checks
+------
+
+Documentation for the ``checks`` sub-sections of attribute specs.
+
+unterminated-ok
+~~~~~~~~~~~~~~~
+
+Accept strings without the null-termination (for legacy families only).
+Switches from the ``NLA_NUL_STRING`` to ``NLA_STRING`` policy type.
+
+max-len
+~~~~~~~
+
+Defines max length for a binary or string attribute (corresponding
+to the ``len`` member of struct nla_policy). For string attributes terminating
+null character is not counted towards ``max-len``.
+
+The field may either be a literal integer value or a name of a defined
+constant. String types may reduce the constant by one
+(i.e. specify ``max-len: CONST - 1``) to reserve space for the terminating
+character so implementations should recognize such pattern.
+
+min-len
+~~~~~~~
+
+Similar to ``max-len`` but defines minimum length.
diff --git a/Documentation/userspace-api/netlink/c-code-gen.rst b/Documentation/userspace-api/netlink/c-code-gen.rst
new file mode 100644
index 000000000000..89de42c13350
--- /dev/null
+++ b/Documentation/userspace-api/netlink/c-code-gen.rst
@@ -0,0 +1,107 @@
+.. SPDX-License-Identifier: BSD-3-Clause
+
+==============================
+Netlink spec C code generation
+==============================
+
+This document describes how Netlink specifications are used to render
+C code (uAPI, policies etc.). It also defines the additional properties
+allowed in older families by the ``genetlink-c`` protocol level,
+to control the naming.
+
+For brevity this document refers to ``name`` properties of various
+objects by the object type. For example ``$attr`` is the value
+of ``name`` in an attribute, and ``$family`` is the name of the
+family (the global ``name`` property).
+
+The upper case is used to denote literal values, e.g. ``$family-CMD``
+means the concatenation of ``$family``, a dash character, and the literal
+``CMD``.
+
+The names of ``#defines`` and enum values are always converted to upper case,
+and with dashes (``-``) replaced by underscores (``_``).
+
+If the constructed name is a C keyword, an extra underscore is
+appended (``do`` -> ``do_``).
+
+Globals
+=======
+
+``c-family-name`` controls the name of the ``#define`` for the family
+name, default is ``$family-FAMILY-NAME``.
+
+``c-version-name`` controls the name of the ``#define`` for the version
+of the family, default is ``$family-FAMILY-VERSION``.
+
+``max-by-define`` selects if max values for enums are defined as a
+``#define`` rather than inside the enum.
+
+Definitions
+===========
+
+Constants
+---------
+
+Every constant is rendered as a ``#define``.
+The name of the constant is ``$family-$constant`` and the value
+is rendered as a string or integer according to its type in the spec.
+
+Enums and flags
+---------------
+
+Enums are named ``$family-$enum``. The full name can be set directly
+or suppressed by specifying the ``enum-name`` property.
+Default entry name is ``$family-$enum-$entry``.
+If ``name-prefix`` is specified it replaces the ``$family-$enum``
+portion of the entry name.
+
+Boolean ``render-max`` controls creation of the max values
+(which are enabled by default for attribute enums).
+
+Attributes
+==========
+
+Each attribute set (excluding fractional sets) is rendered as an enum.
+
+Attribute enums are traditionally unnamed in netlink headers.
+If naming is desired ``enum-name`` can be used to specify the name.
+
+The default attribute name prefix is ``$family-A`` if the name of the set
+is the same as the name of the family and ``$family-A-$set`` if the names
+differ. The prefix can be overridden by the ``name-prefix`` property of a set.
+The rest of the section will refer to the prefix as ``$pfx``.
+
+Attributes are named ``$pfx-$attribute``.
+
+Attribute enums end with two special values ``__$pfx-MAX`` and ``$pfx-MAX``
+which are used for sizing attribute tables.
+These two names can be specified directly with the ``attr-cnt-name``
+and ``attr-max-name`` properties respectively.
+
+If ``max-by-define`` is set to ``true`` at the global level ``attr-max-name``
+will be specified as a ``#define`` rather than an enum value.
+
+Operations
+==========
+
+Operations are named ``$family-CMD-$operation``.
+If ``name-prefix`` is specified it replaces the ``$family-CMD``
+portion of the name.
+
+Similarly to attribute enums operation enums end with special count and max
+attributes. For operations those attributes can be renamed with
+``cmd-cnt-name`` and ``cmd-max-name``. Max will be a define if ``max-by-define``
+is ``true``.
+
+Multicast groups
+================
+
+Each multicast group gets a define rendered into the kernel uAPI header.
+The name of the define is ``$family-MCGRP-$group``, and can be overwritten
+with the ``c-define-name`` property.
+
+Code generation
+===============
+
+uAPI header is assumed to come from ``<linux/$family.h>`` in the default header
+search path. It can be changed using the ``uapi-header`` global property.
diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/Documentation/userspace-api/netlink/genetlink-legacy.rst
new file mode 100644
index 000000000000..65cbbffee0bf
--- /dev/null
+++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
@@ -0,0 +1,96 @@
+.. SPDX-License-Identifier: BSD-3-Clause
+
+=================================================================
+Netlink specification support for legacy Generic Netlink families
+=================================================================
+
+This document describes the many additional quirks and properties
+required to describe older Generic Netlink families which form
+the ``genetlink-legacy`` protocol level.
+
+The spec is a work in progress, some of the quirks are just documented
+for future reference.
+
+Specification (defined)
+=======================
+
+Attribute type nests
+--------------------
+
+New Netlink families should use ``multi-attr`` to define arrays.
+Older families (e.g. ``genetlink`` control family) attempted to
+define array types reusing attribute type to carry information.
+
+For reference the ``multi-attr`` array may look like this::
+
+  [ARRAY-ATTR]
+    [INDEX (optionally)]
+    [MEMBER1]
+    [MEMBER2]
+  [SOME-OTHER-ATTR]
+  [ARRAY-ATTR]
+    [INDEX (optionally)]
+    [MEMBER1]
+    [MEMBER2]
+
+where ``ARRAY-ATTR`` is the array entry type.
+
+array-nest
+~~~~~~~~~~
+
+``array-nest`` creates the following structure::
+
+  [SOME-OTHER-ATTR]
+  [ARRAY-ATTR]
+    [ENTRY]
+      [MEMBER1]
+      [MEMBER2]
+    [ENTRY]
+      [MEMBER1]
+      [MEMBER2]
+
+It wraps the entire array in an extra attribute (hence limiting its size
+to 64kB). The ``ENTRY`` nests are special and have the index of the entry
+as their type instead of normal attribute type.
+
+type-value
+~~~~~~~~~~
+
+``type-value`` is a construct which uses attribute types to carry
+information about a single object (often used when array is dumped
+entry-by-entry).
+
+``type-value`` can have multiple levels of nesting, for example
+genetlink's policy dumps create the following structures::
+
+  [POLICY-IDX]
+    [ATTR-IDX]
+      [POLICY-INFO-ATTR1]
+      [POLICY-INFO-ATTR2]
+
+Where the first level of nest has the policy index as it's attribute
+type, it contains a single nest which has the attribute index as its
+type. Inside the attr-index nest are the policy attributes. Modern
+Netlink families should have instead defined this as a flat structure,
+the nesting serves no good purpose here.
+
+Other quirks (todo)
+===================
+
+Structures
+----------
+
+Legacy families can define C structures both to be used as the contents
+of an attribute and as a fixed message header. The plan is to define
+the structs in ``definitions`` and link the appropriate attrs.
+
+Multi-message DO
+----------------
+
+New Netlink families should never respond to a DO operation with multiple
+replies, with ``NLM_F_MULTI`` set. Use a filtered dump instead.
+
+At the spec level we can define a ``dumps`` property for the ``do``,
+perhaps with values of ``combine`` and ``multi-object`` depending
+on how the parsing should be implemented (parse into a single reply
+vs list of objects i.e. pretty much a dump).
diff --git a/Documentation/userspace-api/netlink/index.rst b/Documentation/userspace-api/netlink/index.rst
index b0c21538d97d..be250110c8f6 100644
--- a/Documentation/userspace-api/netlink/index.rst
+++ b/Documentation/userspace-api/netlink/index.rst
@@ -10,3 +10,8 @@ Netlink documentation for users.
    :maxdepth: 2
 
    intro
+   specs
+   c-code-gen
+   genetlink-legacy
+
+See also :ref:`Documentation/core-api/netlink.rst <kernel_netlink>`.
diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentation/userspace-api/netlink/specs.rst
new file mode 100644
index 000000000000..8394d74fc63a
--- /dev/null
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -0,0 +1,422 @@
+.. SPDX-License-Identifier: BSD-3-Clause
+
+=========================================
+Netlink protocol specifications (in YAML)
+=========================================
+
+Netlink protocol specifications are complete, machine readable descriptions of
+Netlink protocols written in YAML. The goal of the specifications is to allow
+separating Netlink parsing from user space logic and minimize the amount of
+hand written Netlink code for each new family, command, attribute.
+Netlink specs should be complete and not depend on any other spec
+or C header file, making it easy to use in languages which can't include
+kernel headers directly.
+
+Internally kernel uses the YAML specs to generate:
+
+ - the C uAPI header
+ - documentation of the protocol as a ReST file
+ - policy tables for input attribute validation
+ - operation tables
+
+YAML specifications can be found under ``Documentation/netlink/specs/``
+
+Compatibility levels
+====================
+
+There are four schema levels for Netlink specs, from the simplest used
+by new families to the most complex covering all the quirks of the old ones.
+Each next level inherits the attributes of the previous level, meaning that
+user capable of parsing more complex ``genetlink`` schemas is also compatible
+with simpler ones. The levels are:
+
+ - ``genetlink`` - most streamlined, should be used by all new families
+ - ``genetlink-c`` - superset of ``genetlink`` with extra attributes allowing
+   customization of define and enum type and value names; this schema should
+   be equivalent to ``genetlink`` for all implementations which don't interact
+   directly with C uAPI headers
+ - ``genetlink-legacy`` - Generic Netlink catch all schema supporting quirks of
+   all old genetlink families, strange attribute formats, binary structures etc.
+ - ``netlink-raw`` - catch all schema supporting pre-Generic Netlink protocols
+   such as ``NETLINK_ROUTE``
+
+The definition of the schemas (in ``jsonschema``) can be found
+under ``Documentation/netlink/``.
+
+Schema structure
+================
+
+YAML schema has the following conceptual sections:
+
+ - globals
+ - definitions
+ - attributes
+ - operations
+ - multicast groups
+
+Most properties in the schema accept (or in fact require) a ``doc``
+sub-property documenting the defined object.
+
+The following sections describe the properties of the most modern ``genetlink``
+schema. See the documentation of :doc:`genetlink-c <c-code-gen>`
+for information on how C names are derived from name properties.
+
+genetlink
+=========
+
+Globals
+-------
+
+Attributes listed directly at the root level of the spec file.
+
+name
+~~~~
+
+Name of the family. Name identifies the family in a unique way, since
+the Family IDs are allocated dynamically.
+
+version
+~~~~~~~
+
+Generic Netlink family version, default is 1.
+
+protocol
+~~~~~~~~
+
+The schema level, default is ``genetlink``, which is the only value
+allowed for new ``genetlink`` families.
+
+definitions
+-----------
+
+Array of type and constant definitions.
+
+name
+~~~~
+
+Name of the type / constant.
+
+type
+~~~~
+
+One of the following types:
+
+ - const - a single, standalone constant
+ - enum - defines an integer enumeration, with values for each entry
+   incrementing by 1, (e.g. 0, 1, 2, 3)
+ - flags - defines an integer enumeration, with values for each entry
+   occupying a bit, starting from bit 0, (e.g. 1, 2, 4, 8)
+
+value
+~~~~~
+
+The value for the ``const``.
+
+value-start
+~~~~~~~~~~~
+
+The first value for ``enum`` and ``flags``, allows overriding the default
+start value of ``0`` (for ``enum``) and starting bit (for ``flags``).
+For ``flags`` ``value-start`` selects the starting bit, not the shifted value.
+
+Sparse enumerations are not supported.
+
+entries
+~~~~~~~
+
+Array of names of the entries for ``enum`` and ``flags``.
+
+header
+~~~~~~
+
+For C-compatible languages, header which already defines this value.
+In case the definition is shared by multiple families (e.g. ``IFNAMSIZ``)
+code generators for C-compatible languages may prefer to add an appropriate
+include instead of rendering a new definition.
+
+attribute-sets
+--------------
+
+This property contains information about netlink attributes of the family.
+All families have at least one attribute set, most have multiple.
+``attribute-sets`` is an array, with each entry describing a single set.
+
+Note that the spec is "flattened" and is not meant to visually resemble
+the format of the netlink messages (unlike certain ad-hoc documentation
+formats seen in kernel comments). In the spec subordinate attribute sets
+are not defined inline as a nest, but defined in a separate attribute set
+referred to with a ``nested-attributes`` property of the container.
+
+Spec may also contain fractional sets - sets which contain a ``subset-of``
+property. Such sets describe a section of a full set, allowing narrowing down
+which attributes are allowed in a nest or refining the validation criteria.
+Fractional sets can only be used in nests. They are not rendered to the uAPI
+in any fashion.
+
+name
+~~~~
+
+Uniquely identifies the attribute set, operations and nested attributes
+refer to the sets by the ``name``.
+
+subset-of
+~~~~~~~~~
+
+Re-defines a portion of another set (a fractional set).
+Allows narrowing down fields and changing validation criteria
+or even types of attributes depending on the nest in which they
+are contained. The ``value`` of each attribute in the fractional
+set is implicitly the same as in the main set.
+
+attributes
+~~~~~~~~~~
+
+List of attributes in the set.
+
+Attribute properties
+--------------------
+
+name
+~~~~
+
+Identifies the attribute, unique within the set.
+
+type
+~~~~
+
+Netlink attribute type, see :ref:`attr_types`.
+
+.. _assign_val:
+
+value
+~~~~~
+
+Numerical attribute ID, used in serialized Netlink messages.
+The ``value`` property can be skipped, in which case the attribute ID
+will be the value of the previous attribute plus one (recursively)
+and ``0`` for the first attribute in the attribute set.
+
+Note that the ``value`` of an attribute is defined only in its main set.
+
+enum
+~~~~
+
+For integer types specifies that values in the attribute belong
+to an ``enum`` or ``flags`` from the ``definitions`` section.
+
+enum-as-flags
+~~~~~~~~~~~~~
+
+Treat ``enum`` as ``flags`` regardless of its type in ``definitions``.
+When both ``enum`` and ``flags`` forms are needed ``definitions`` should
+contain an ``enum`` and attributes which need the ``flags`` form should
+use this attribute.
+
+nested-attributes
+~~~~~~~~~~~~~~~~~
+
+Identifies the attribute space for attributes nested within given attribute.
+Only valid for complex attributes which may have sub-attributes.
+
+multi-attr (arrays)
+~~~~~~~~~~~~~~~~~~~
+
+Boolean property signifying that the attribute may be present multiple times.
+Allowing an attribute to repeat is the recommended way of implementing arrays
+(no extra nesting).
+
+byte-order
+~~~~~~~~~~
+
+For integer types specifies attribute byte order - ``little-endian``
+or ``big-endian``.
+
+checks
+~~~~~~
+
+Input validation constraints used by the kernel. User space should query
+the policy of the running kernel using Generic Netlink introspection,
+rather than depend on what is specified in the spec file.
+
+The validation policy in the kernel is formed by combining the type
+definition (``type`` and ``nested-attributes``) and the ``checks``.
+
+operations
+----------
+
+This section describes messages passed between the kernel and the user space.
+There are three types of entries in this section - operations, notifications
+and events.
+
+Operations describe the most common request - response communication. User
+sends a request and kernel replies. Each operation may contain any combination
+of the two modes familiar to netlink users - ``do`` and ``dump``.
+``do`` and ``dump`` in turn contain a combination of ``request`` and
+``response`` properties. If no explicit message with attributes is passed
+in a given direction (e.g. a ``dump`` which does not accept filter, or a ``do``
+of a SET operation to which the kernel responds with just the netlink error
+code) ``request`` or ``response`` section can be skipped.
+``request`` and ``response`` sections list the attributes allowed in a message.
+The list contains only the names of attributes from a set referred
+to by the ``attribute-set`` property.
+
+Notifications and events both refer to the asynchronous messages sent by
+the kernel to members of a multicast group. The difference between the
+two is that a notification shares its contents with a GET operation
+(the name of the GET operation is specified in the ``notify`` property).
+This arrangement is commonly used for notifications about
+objects where the notification carries the full object definition.
+
+Events are more focused and carry only a subset of information rather than full
+object state (a made up example would be a link state change event with just
+the interface name and the new link state). Events contain the ``event``
+property. Events are considered less idiomatic for netlink and notifications
+should be preferred.
+
+list
+~~~~
+
+The only property of ``operations`` for ``genetlink``, holds the list of
+operations, notifications etc.
+
+Operation properties
+--------------------
+
+name
+~~~~
+
+Identifies the operation.
+
+value
+~~~~~
+
+Numerical message ID, used in serialized Netlink messages.
+The same enumeration rules are applied as to
+:ref:`attribute values<assign_val>`.
+
+attribute-set
+~~~~~~~~~~~~~
+
+Specifies the attribute set contained within the message.
+
+do
+~~~
+
+Specification for the ``doit`` request. Should contain ``request``, ``reply``
+or both of these properties, each holding a :ref:`attr_list`.
+
+dump
+~~~~
+
+Specification for the ``dumpit`` request. Should contain ``request``, ``reply``
+or both of these properties, each holding a :ref:`attr_list`.
+
+notify
+~~~~~~
+
+Designates the message as a notification. Contains the name of the operation
+(possibly the same as the operation holding this property) which shares
+the contents with the notification (``do``).
+
+event
+~~~~~
+
+Specification of attributes in the event, holds a :ref:`attr_list`.
+``event`` property is mutually exclusive with ``notify``.
+
+mcgrp
+~~~~~
+
+Used with ``event`` and ``notify``, specifies which multicast group
+message belongs to.
+
+.. _attr_list:
+
+Message attribute list
+----------------------
+
+``request``, ``reply`` and ``event`` properties have a single ``attributes``
+property which holds the list of attribute names.
+
+Messages can also define ``pre`` and ``post`` properties which will be rendered
+as ``pre_doit`` and ``post_doit`` calls in the kernel (these properties should
+be ignored by user space).
+
+mcast-groups
+------------
+
+This section lists the multicast groups of the family.
+
+list
+~~~~
+
+The only property of ``mcast-groups`` for ``genetlink``, holds the list
+of groups.
+
+Multicast group properties
+--------------------------
+
+name
+~~~~
+
+Uniquely identifies the multicast group in the family. Similarly to
+Family ID, Multicast Group ID needs to be resolved at runtime, based
+on the name.
+
+.. _attr_types:
+
+Attribute types
+===============
+
+This section describes the attribute types supported by the ``genetlink``
+compatibility level. Refer to documentation of different levels for additional
+attribute types.
+
+Scalar integer types
+--------------------
+
+Fixed-width integer types:
+``u8``, ``u16``, ``u32``, ``u64``, ``s8``, ``s16``, ``s32``, ``s64``.
+
+Note that types smaller than 32 bit should be avoided as using them
+does not save any memory in Netlink messages (due to alignment).
+See :ref:`pad_type` for padding of 64 bit attributes.
+
+The payload of the attribute is the integer in host order unless ``byte-order``
+specifies otherwise.
+
+.. _pad_type:
+
+pad
+---
+
+Special attribute type used for padding attributes which require alignment
+bigger than standard 4B alignment required by netlink (e.g. 64 bit integers).
+There can only be a single attribute of the ``pad`` type in any attribute set
+and it should be automatically used for padding when needed.
+
+flag
+----
+
+Attribute with no payload, its presence is the entire information.
+
+binary
+------
+
+Raw binary data attribute, the contents are opaque to generic code.
+
+string
+------
+
+Character string. Unless ``checks`` has ``unterminated-ok`` set to ``true``
+the string is required to be null terminated.
+``max-len`` in ``checks`` indicates the longest possible string,
+if not present the length of the string is unbounded.
+
+Note that ``max-len`` does not count the terminating character.
+
+nest
+----
+
+Attribute containing other (nested) attributes.
+``nested-attributes`` specifies which attribute set is used inside.
diff --git a/MAINTAINERS b/MAINTAINERS
index f82dd8d43c2b..3842915d863d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14563,8 +14563,10 @@ Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 B:	mailto:netdev@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
+F:	Documentation/core-api/netlink.rst
 F:	Documentation/networking/
 F:	Documentation/process/maintainer-netdev.rst
+F:	Documentation/userspace-api/netlink/
 F:	include/linux/in.h
 F:	include/linux/net.h
 F:	include/linux/netdevice.h
-- 
2.39.0

